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
        perform
      end

      def ready?
        throw "#{self.class.name}#ready? must be defined"
      end

      def perform
        throw "#{self.class.name}#perform must be defined"
      end

      def wait_for(jobs)
        if async?
          throw "To handle"
        else
          [*jobs].each(&:run)
        end
      end


      # Resque
      def self.perform(opts = {})
        new(opts).run
      end

      def enqueue
        Resque.enqueue(self.class, self.arguments.merge('async' => true))
      end


      private

      def aync?
        !!@arguments['async']
      end

    end

  end
end
