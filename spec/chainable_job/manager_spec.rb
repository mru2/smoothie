require 'spec_helper'
require 'chainable_job/manager'

describe Smoothie::ChainableJob::Manager do

  class JobClass ; end

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

  let(:manager){Smoothie::ChainableJob::Manager.new(job)}

  describe "#enqueue" do

    it "should enqueue the job" do

      Resque.should_receive(:enqueue).with(job_class, job_arguments)
      manager.enqueue()

    end

    it "should only enqueue it once" do

      Resque.should_receive(:enqueue).once.with(job_class, job_arguments)

      3.times do
        manager.enqueue()
      end

    end

    it "should enqueue the callback" do

      Resque.should_receive(:enqueue).once.with(job_class, job_arguments)
      Resque.should_not_receive(:enqueue).with(job_class, another_job_arguments)

      manager.enqueue(another_job)

      manager.callbacks.should                      == [another_job.serialize]
      Smoothie::ChainableJob::Manager.new(another_job).dependencies.should  == [job.serialize]

    end

    it "should run the jobs whose dependencies are satisfied on finish" do

      Resque.should_receive(:enqueue).with(job_class, job_arguments)
      manager.enqueue(another_job)

      manager.send(:enqueued?).should be_true

      # manager.should_receive(:enqueue).once.with([job_class, another_job_arguments].to_json)
      JobClass.stub!(:new).and_return(another_job)
      Resque.should_receive(:enqueue).with(job_class, another_job_arguments)
      manager.finished

      manager.send(:enqueued?).should be_false
      Smoothie::ChainableJob::Manager.new(another_job).send(:enqueued?).should be_true

    end

  end
  
end