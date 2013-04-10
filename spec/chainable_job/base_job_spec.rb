require 'spec_helper'
require 'chainable_job/base_job'

describe Smoothie::ChainableJob::BaseJob do
 
  # The jobs the testing is going to be on
  class Job1 < Smoothie::ChainableJob::BaseJob
    @queue = :default

    attr_accessor :ready

    def ready?
      @ready
    end

    def perform
      # Simulate timeout
      sleep(2)

      @ready = true
    end
  end


  class Job2 < Smoothie::ChainableJob::BaseJob
    @queue = :default

    attr_accessor :ready

    def initialize(opts)
      @job = opts[:job_to_wait_for]
    end

    def ready?
      @ready
    end

    def perform
      do_stuff_before

      # Forward to job 1
      wait_for @job

      do_stuff_after

      @ready = true
    end

    private

    def do_stuff_before
    end

    def do_stuff_after
    end
  end

  let(:job1){Job1.new}
  let(:job2){Job2.new(:job_to_wait_for => job1)}


  describe "synchronously" do

    describe "#wait_for" do

      it "should execute, wait for the other job, and resume execution" do

        job2.should_receive(:do_stuff_before).ordered
        job1.should_receive(:perform).ordered
        job2.should_receive(:do_stuff_after).ordered

        job2.run

      end

      it "should not call the other job if ready" do

        job1.ready = true

        job2.should_receive(:do_stuff_before).ordered
        job1.should_not_receive(:perform)
        job2.should_receive(:do_stuff_after).ordered

        job2.run

      end

    end

  end


  describe "asynchronously" do

    describe "#wait_for" do

      it "should call the manager" do

        # The job beginning
        job2.should_receive(:do_stuff_before).ordered

        # Returning before
        job2.should_not_receive(:do_stuff_after).ordered

        job2.async_run

      end

    end

  end

end