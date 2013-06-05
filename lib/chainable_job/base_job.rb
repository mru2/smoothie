require 'chainable_job/manager'

module Smoothie
  module ChainableJob

    class BaseJob

      attr_accessor :arguments
      attr_accessor :force          

      def initialize(opts = {})
        @arguments = opts
        @force_execution = !!@arguments.delete('force')
      end

      def run
        catch(:stop_job) do
          perform unless is_ready?
          manager.finished
        end
      end

      def is_ready?
        @force_execution ? false : ready?
      end

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
        unready_jobs = [*jobs].select{|job|!job.is_ready?}

        unless unready_jobs.empty?
          if @async
            unready_jobs.each do |job|
              job.manager.enqueue(self)
            end

            # Remove self from the queue (keep its callbacks and dependencies though)
            manager.waiting

            throw :stop_job # Halt the execution of the current worker
          else
            unready_jobs.each(&:run)
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

      private

      def aync?
        !!@arguments['async']
      end

      def ready?
        raise "#{self.class.name}#ready? must be defined"
      end

    end

  end
end
