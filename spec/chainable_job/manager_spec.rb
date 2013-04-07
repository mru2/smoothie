require 'spec_helper'
require 'chainable_job/manager'

describe Smoothie::ChainableJob::Manager do

  class JobClass ; end

  let(:manager){Smoothie::ChainableJob::Manager}

  let(:job_class){JobClass}
  let(:job_arguments){ {'arg1' => 'val1', 'arg2' => 'val2'} }
  let(:job){
    job = mock("job")
    job.stub!(:class)     .and_return(job_class)
    job.stub!(:arguments) .and_return(job_arguments)
    job.stub!(:serialize) .and_return([job_class, job_arguments].to_json)
    job
  }

  describe "#enqueue" do

    it "should enqueue the job" do

      Resque.should_receive(:enqueue).with(job_class, job_arguments)
      manager.enqueue(job)

    end

    it "should only enqueue it once" do

      Resque.should_receive(:enqueue).once.with(job_class, job_arguments)

      3.times do
        manager.enqueue(job)
      end

    end

  end
  
end