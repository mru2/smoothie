module Smoothie
  module ChainableJob

    # Responsible for managing job dependencies, and enqueuing them accordingly
    class Manager

      # # Enqueue a job and optionally a callback dependant on him
      # def enqueue(job, callback = nil)
      #   managed_job = ManagedJob.new(job)

      #   # Enqueue the job (if not already)
      #   managed_job.enqueue(Resque)

      #   # Add the callback
      #   if callback
      #     managed_callback = ManagedJob.new(callback)

      #     managed_callback.add_dependency(managed_job)
      #     managed_job.add_callback(managed_callback)
      #   end
      # end


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

    end

  end
end
