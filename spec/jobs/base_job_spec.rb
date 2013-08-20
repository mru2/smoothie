require 'spec_helper'
require 'base_job'

describe Smoothie::BaseJob do
 
  # To test method calls
  class External
    class << self
      def doing_job_1 ; end
      def before_job_2 ; end
      def after_job_2 ; end
    end
  end

  # The jobs the testing is going to be on
  class Job1 < Smoothie::BaseJob
    @queue = :default

    attr_accessor :ready

    def ready?
      @ready
    end

    def perform
      # Simulate timeout
      sleep(2)

      External.doing_job_1(arguments)

      @ready = true
    end
  end


  class Job2 < Smoothie::BaseJob
    @queue = :default

    attr_accessor :ready

    def ready?
      @ready
    end

    def perform
      External.before_job_2

      # Forward to job 1
      wait_for Job1.new

      External.after_job_2

      @ready = true
    end

    private

    def do_stuff_before
    end

    def do_stuff_after
    end
  end

  let(:job1){Job1.new}
  let(:job2){Job2.new}


  # it "should forward the force flag" do

  #   job2.arguments['force'] = true
  #   External.should_receive(:doing_job_1).with('force' => true)

  #   job2.run

  # end


  describe "equality" do

    it "should be equal to a job of the same class with the same arguments" do
      job_a = Job1.new(:attribute => 'value')
      job_b = Job1.new(:attribute => 'value')
      job_c = Job1.new(:attribute => 'other_value')
      job_d = Job2.new(:attribute => 'value')

      job_a.object_id.should_not == job_b.object_id

      job_a.should == job_b
      job_a.should_not == job_c
      job_a.should_not == job_d
    end

  end



  describe "synchronously" do

    # describe "#wait_for" do


    #   it "should execute, wait for the other job, and resume execution" do

    #     External.should_receive(:before_job_2).ordered
    #     External.should_receive(:doing_job_1).ordered
    #     External.should_receive(:after_job_2).ordered

    #     job2.run

    #   end

    #   it "should not call the other job if ready" do

    #     job1.ready = true
    #     Job1.stub(:new).and_return(job1)

    #     External.should_receive(:before_job_2).ordered
    #     External.should_not_receive(:doing_job_1)
    #     External.should_receive(:after_job_2).ordered

    #     job2.run

    #   end

    #   it "should tell the manager it is finished" do

    #     job2.ready = true
    #     job2.manager.should_receive :finished
    #     job2.run

    #   end

    # end

  end


  describe "asynchronously" do

    # describe "#wait_for" do

    #   it "should call the manager" do

    #     # The job beginning
    #     External.should_receive(:before_job_2).ordered

    #     # Returning before
    #     External.should_not_receive(:after_job_2).ordered

    #     job2.async_run

    #   end

    # end

  end

end