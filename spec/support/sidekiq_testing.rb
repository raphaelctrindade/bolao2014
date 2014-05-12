# see https://github.com/mperham/sidekiq/wiki/Testing
require 'sidekiq/testing'

RSpec.configure do |config|
  config.before(:each) do |example_method|
    # Clears out the jobs for tests using the fake testing
    Sidekiq::Worker.clear_all

    # Get the current example from the example_method object
    example = example_method.example

    if example.metadata[:sidekiq] == :fake
      Sidekiq::Testing.fake!
    elsif example.metadata[:sidekiq] == :inline
      Sidekiq::Testing.inline!
    elsif example.metadata[:type] == :acceptance
      Sidekiq::Testing.inline!
    else
      Sidekiq::Testing.fake!
    end
  end
end
