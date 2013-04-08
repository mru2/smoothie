require 'chainable_job/manager'

module Smoothie
  module ChainableJob

    class BaseJob

      # The exception used to halt a worker
      StopJob = Class.new(Interrupt) 

      attr_accessor :arguments

      def initialize(opts = {})
        @arguments = opts
      end

      def run
        return if ready?

        begin
          perform 
        rescue StopJob
          return # A waiting_for has been encountered, the job will be run again when its confitions are met
        end
      end

      def async_run
        @async = true
        run
      end

      def ready?
        throw "#{self.class.name}#ready? must be defined"
      end

      def perform
        throw "#{self.class.name}#perform must be defined"
      end

      def wait_for(jobs)
        unready_jobs = [*jobs].select{|job|!job.ready?}

        unless unready_jobs.empty?
          if @async
            unready_jobs.each do |job|
              Manager.new(job).enqueue(self)
            end

            # Remove self from the queue (keep its callbacks and dependencies though)
            Manager.new(self).dequeue

            raise StopJob # Halt the execution of the current worker
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
