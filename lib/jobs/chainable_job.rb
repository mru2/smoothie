module Smoothie
  class ChainableJob

    attr_accessor :callbacks
    attr_accessor :arguments

    def initialize(opts)
      self.arguments = opts
      initialize_callbacks
    end

    def run
      if !ready?
        perform
      end

      run_callbacks
    end

    def ready?
      throw "#{self.class.name}#ready? must be defined"
    end

    def perform
      throw "#{self.class.name}#perform must be defined"
    end


    def wait_for(jobs)
      [*jobs].each(&:run)
    end


    private

    def run_callbacks
      callbacks.each do |callback|
        callback.run
      end
    end

    def initialize_callbacks
      self.callbacks = []

      if arguments["callbacks"]
        arguments["callbacks"].each do |serialized_callback|
          self.callbacks << ChainableJob.parse_callback(serialized_callback)
        end
      end
    end

    def to_callback
      {"class" => self.class.name, "args" => arguments}
    end

    def self.parse_callback(callback_args)
      callback_args["class"].constantize.new(callback_args["args"])
    end

  end
end
