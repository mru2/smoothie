module Smoothie
  module ChainableJob

    # Responsible for managing job dependencies, and enqueuing them accordingly
    class Manager

      attr_reader :job
      attr_reader :job_uid

      def initialize(job)
        if job.is_a?(String)
          @job_uid = job
          @job = Manager.unserialize(job)
        else
          @job_uid = Manager.serialize(job)
          @job = job
        end
      end


      # Enqueue a job and optionally a callback
      def enqueue(callback = nil)

        # Enqueue the job if not already done
        enqueue_job

        # Store the dependency/callback relationship
        if callback
          set_callback(callback)
        end
      end


      # Mark a job as finished and launch its callbacks accordingly
      def finished

        # Update its callbacks
        callbacks.each do |callback|

          callback_manager = Manager.new(callback)

          # Clear their dependency
          callback_manager.dependencies.delete(@job_uid)

          # Enqueue them if they are ready
          callback_manager.enqueue if callback_manager.dependencies.empty?
        end

        # Mark the job as not in the queue anymore
        destroy

      end


      # Get a job's stored serialized callbacks
      def callbacks
        @callbacks ||= Redis::Set.new("chainable_job:manager:callbacks:#{@job_uid}")
      end

      # Get a job's stored serialized dependencies
      def dependencies
        @dependencies ||= Redis::Set.new("chainable_job:manager:dependencies:#{@job_uid}")
      end

      def enqueued?
        Manager.queued_jobs.member?(@job_uid)
      end

      def dequeue
        # Remove itself from the queue
        Manager.queued_jobs.delete(@job_uid)
      end

      def destroy
        dequeue

        # Destroys its callbacks and dependencies sets
        callbacks.clear
        dependencies.clear
      end


      private 

      # Enqueue a job if not already done
      def enqueue_job
        if !enqueued?
          Resque.enqueue(@job.class, @job.arguments)
          Manager.queued_jobs << @job_uid
        end
      end

      # Stores the symetric relationship between a job and its callback
      def set_callback(callback)
        callback_manager = Manager.new(callback)

        callbacks                     << callback_manager.job_uid
        callback_manager.dependencies << @job_uid
      end


      class << self

        # The job queue
        def queued_jobs
          Redis::Set.new('chainable_job:manager:queued_jobs')
        end

        def serialize(job)
          [job.class.name, job.arguments].to_json
        end

        def unserialize(job_dump)
          a = JSON.load(job_dump)
          Object.const_get(a[0]).new(a[1])
        end

      end

    end
  end
end
