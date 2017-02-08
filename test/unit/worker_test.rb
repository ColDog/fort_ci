require "test_helper"

class TestJob
  def initialize(data)
    @data = data
  end

  def self.runs
    @runs ||= 0
  end

  def self.runs=(val)
    @runs = val
  end

  def perform
    self.class.runs += 1
  end
end

describe FortCI::Worker do
  it "can enqueue" do
    start = FortCI::Worker::WorkerJob.count
    FortCI::Worker.executor.enqueue(
        job_class: TestJob.name,
        data: {test: true},
    )
    assert_equal start + 1, FortCI::Worker::WorkerJob.count
  end

  it "can run" do
    FortCI::Worker.executor.enqueue(
        job_class: TestJob.name,
        data: {test: true},
    )

    FortCI::Worker.executor.run(1)
    assert TestJob.runs >= 1
  end
end
