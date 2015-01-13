require "spec_helper"

describe LittleBigAdmin::Formatter do

  describe ".choose_format" do

    it "returns :date for dates" do
      expect(LittleBigAdmin::Formatter.choose_format(Date.parse("2012-12-12"))).to eq :date
    end

    it "returns :date for times" do
      expect(LittleBigAdmin::Formatter.choose_format(Time.now)).to eq :date
    end

    it "returns :date for times with zones" do
      expect(LittleBigAdmin::Formatter.choose_format(Time.zone.now)).to eq :date
    end

    it "returns :default for strings" do
      expect(LittleBigAdmin::Formatter.choose_format("Tester")).to eq :default
    end
  end


  describe ".run" do 
    it "returns a truncated value for default strings" do
      expect(LittleBigAdmin::Formatter.run("a "* 120,:default)).to eq "a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a a..." 
    end

    it "allows overriding the truncation length" do
      expect(LittleBigAdmin::Formatter.run("a "* 20,:default, length: 20)).to eq "a a a a a a a a a..."
    end

    it "returns the formatted date for :date formats" do
      expect(LittleBigAdmin::Formatter.run(Date.parse("2012-12-2"),:date)).to eq "12/2/2012"
    end
  end


  describe ".format" do
  
    let(:obj) { double(:my_obj, created_at: Date.parse("2012-12-2")) }

    it "picks the right format and returns the output of the formatter for dates" do
      expect(LittleBigAdmin::Formatter.format(obj, :created_at)).to eq "12/2/2012"
    end
  end
end
