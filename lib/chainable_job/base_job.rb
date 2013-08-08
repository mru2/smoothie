require 'chainable_job/manager'

module Smoothie
  module ChainableJob

    class BaseJob

      attr_accessor :arguments

      def initialize(opts = {})
        @arguments = opts
      end

      def run
        perform unless ready?
      end

      def async_run
        Resque.enqueue(self.class, self.arguments) unless ready?
      end

      def perform
        raise "#{self.class.name}#perform must be defined"
      end

      # Resque
      def self.perform(opts = {})
        new(opts).run
      end

      # Equality : only class name and arguments are important here
      def ==(job)
        (self.class == job.class) && (self.arguments == job.arguments)
      end

      private

      def ready?
        raise "#{self.class.name}#ready? must be defined"
      end

    end

  end
end
