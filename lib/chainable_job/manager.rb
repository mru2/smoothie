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


        # # Mark a job as finished and launch its callbacks accordingly
        # def finished(job)
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

        private 

        # Enqueue a job if not already done
        def enqueue_job(job)
          @queued_jobs ||= Redis::Set.new('chainable_job:manager:queued_jobs')

          if !@queued_jobs.member?(job.serialize)
            Resque.enqueue(job.class, job.arguments)
            @queued_jobs << job.serialize
          end        
        end

        # Stores the symetric relationship between a job and its callback
        def set_callback(job, callback)
          callbacks_for(job)         << callback.serialize
          dependencies_for(callback) << job.serialize
        end

      end
    end
  end
end
