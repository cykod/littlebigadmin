require "spec_helper"

describe LittleBigAdmin::Config do

  let(:config) { LittleBigAdmin::Config.new }

  it "allows the title to be set" do
    config.run do |config|
      config.title = "tester"
    end

    expect(config.title).to eq "tester"
  end

  it "returns the default title" do
    expect(config.title).to eq LittleBigAdmin::Config.defaults[:title]
  end

end
