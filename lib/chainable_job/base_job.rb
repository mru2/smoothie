require 'chainable_job/manager'

module Smoothie
  module ChainableJob

    class BaseJob

      attr_accessor :arguments

      def initialize(opts = {})
        @arguments = opts
      end

      def run
        catch(:stop_job) do
          perform unless ready?
          manager.finished
        end
      end

      # def is_ready?
      #   force_execution? ? false : ready?
      # end

      def async_run
        begin
          @async = true
          run
        rescue
          manager.failed
        end
      end

      def perform
        raise "#{self.class.name}#perform must be defined"
      end

      def wait_for(jobs)

        # # Forward the job forcing down the line unless explicitely defined
        # [*jobs].each do |job|
        #   job.arguments['force'] = force_execution? unless job.arguments.has_key?('force')
        # end

        unready_jobs = [*jobs].select{|job|!job.ready?}

        unless unready_jobs.empty?

          # Run each job
          unready_jobs.each do |job|
            if @async
              job.manager.enqueue(self)
            else
              unready_jobs.each(&:run)
            end
          end

          if @async
            # Remove self from the queue (keep its callbacks and dependencies though)
            manager.waiting

            throw :stop_job # Halt the execution of the current worker
          end

        end
      end


      # Resque
      def self.perform(opts = {})
        new(opts).async_run
      end

      # Manager accessor
      def manager
        @manager ||= Manager.new(self)
      end

      # Equality : only class name and arguments are important here
      def ==(job)
        (self.class == job.class) && (self.arguments == job.arguments)
      end

      private

      def aync?
        !!@arguments['async']
      end

      def ready?
        raise "#{self.class.name}#ready? must be defined"
      end

      # def force_execution?
      #   !!@arguments['force']
      # end

    end

  end
end
