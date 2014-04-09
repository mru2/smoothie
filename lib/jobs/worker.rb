require 'thread'

require 'user_syncer'
require 'track_syncer'

module Smoothie::Jobs

  class Worker

    class Runner

      def self.run
        new.run
      end

      def self.threaded_run
        # $soundcloud thread-safe?
        @thread = Thread.new do
          new.run
        end
      end

      def self.stop
        return unless @thread
        @thread.exit
      end

      def run
        puts "Worker running"
        loop do
          job = pop_next_job
          if !job
            puts "No job in queue, sleeping 10 seconds"
            sleep(10) and next
          end

          puts "Running #{job[:class]} for #{job[:id]}"
          job[:class].run(job[:id])
        end
      end

      def pop_next_job
        # Job is type:id
        job = $redis.zrevrange 'smoothie:jobs:queue', 0 , 1
        return nil if job.empty?

        classname, id = job.first.split(':')

        if classname == 'UserSyncer'
          worker = UserSyncer
        elsif  classname == 'TrackSyncer'
          worker = TrackSyncer
        end
          
        {:class => :worker, :id => id.to_i}
      end

    end

    def self.work
      Runner.run
    end

    def self.enqueue(classname, id)
      $redis.zincrby 'smoothie:jobs:queue', 1, "#{classname}:#{id}"
    end

  end

end