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

  let(:another_job_arguments){ {'arg' => 'val'} }
  let(:another_job){
    job = mock("job")
    job.stub!(:class)     .and_return(job_class)
    job.stub!(:arguments) .and_return(another_job_arguments)
    job.stub!(:serialize) .and_return([job_class, another_job_arguments].to_json)
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

    it "should enqueue the callback" do

      Resque.should_receive(:enqueue).once.with(job_class, job_arguments)
      Resque.should_not_receive(:enqueue).with(job_class, another_job_arguments)

      manager.enqueue(job, another_job)

      manager.callbacks_for(job).should             == [another_job.serialize]
      manager.dependencies_for(another_job).should  == [job.serialize]

    end

    it "should run the jobs whose dependencies are satisfied on finish" do

      Resque.should_receive(:enqueue).with(job_class, job_arguments)
      manager.enqueue(job, another_job)

      manager.enqueued?(job).should be_true

      # manager.should_receive(:enqueue).once.with([job_class, another_job_arguments].to_json)
      JobClass.stub!(:new).and_return(another_job)
      Resque.should_receive(:enqueue).with(job_class, another_job_arguments)
      manager.finished(job)

      manager.enqueued?(job).should be_false
      manager.enqueued?(another_job).should be_true

    end

  end
  
end