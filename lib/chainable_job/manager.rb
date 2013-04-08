module Smoothie
  module ChainableJob

    # Responsible for managing job dependencies, and enqueuing them accordingly
    class Manager

      class << self

        # Enqueue a job and optionally a callback
        def enqueue(job, callback = nil)

          # Enqueue the job if not already done
          enqueue_job(job)

          # Store the dependency/callback relationship
          if callback
            set_callback(job, callback)
          end
        end


        # Mark a job as finished and launch its callbacks accordingly
        def finished(job)

          # Mark the job as not in the queue anymore
          dequeue_job(job)

          # Update its callbacks
          callbacks_for(job).each do |callback|

            # Clear their dependency
            dependencies_for(callback).delete(try_serialize(job))

            # Enqueue them if they are ready
            enqueue(callback) if dependencies_for(callback).empty?

          end
        end


        #   managed_job = ManagedJob.new(job)

        #   # Update its callbacks dependencies
        #   managed_job.callbacks.each do |callback|
        #     callback.remove_dependency(managed_job)

        #     # Run them if they are ready
        #     if callback.dependencies.empty?
        #       callback.enqueue(Resque)
        #     end
        #   end
        # end

        # Get a job's stored serialized callbacks
        def callbacks_for(job)
          Redis::Set.new("chainable_job:manager:callbacks:#{try_serialize(job)}")
        end

        # Get a job's stored serialized dependencies
        def dependencies_for(job)
          Redis::Set.new("chainable_job:manager:dependencies:#{try_serialize(job)}")
        end

        def enqueued?(job)
          queued_jobs.member?(try_serialize(job))
        end


        private 

        # Enqueue a job if not already done
        def enqueue_job(job)
          if !enqueued?(job)
            job_object = try_unserialize(job)
            Resque.enqueue(job_object.class, job_object.arguments)
            queued_jobs << try_serialize(job)
          end
        end

        def dequeue_job(job)
          queued_jobs.delete(try_serialize(job))
          dependencies_for(job).clear
        end

        # Stores the symetric relationship between a job and its callback
        def set_callback(job, callback)
          callbacks_for(job)         << try_serialize(callback)
          dependencies_for(callback) << try_serialize(job)
        end

        # The job queue
        def queued_jobs
          Redis::Set.new('chainable_job:manager:queued_jobs')
        end

        def try_serialize(job)
          job.is_a?(String) ? job : job.serialize
        end

        def try_unserialize(job)
          job.is_a?(String) ? BaseJob.unserialize(job) : job
        end

      end
    end
  end
end
