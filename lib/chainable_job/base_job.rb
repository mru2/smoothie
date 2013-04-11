require 'chainable_job/manager'

module Smoothie
  module ChainableJob

    class BaseJob

      attr_accessor :arguments

      def initialize(opts = {})
        @arguments = opts
      end

      def run
        return if ready?

        catch(:stop_job) do
          perform
        end
      end

      def async_run
        @async = true
        run
      end

      def ready?
        raise "#{self.class.name}#ready? must be defined"
      end

      def perform
        raise "#{self.class.name}#perform must be defined"
      end

      def wait_for(jobs)
        unready_jobs = [*jobs].select{|job|!job.ready?}

        unless unready_jobs.empty?
          if @async
            unready_jobs.each do |job|
              Manager.new(job).enqueue(self)
            end

            # Remove self from the queue (keep its callbacks and dependencies though)
            Manager.new(self).waiting

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


      private

      def aync?
        !!@arguments['async']
      end

    end

  end
end
