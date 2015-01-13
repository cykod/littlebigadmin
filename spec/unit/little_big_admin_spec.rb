require "spec_helper"

describe LittleBigAdmin do

  describe ".setup" do
    
    before { LittleBigAdmin.reset }

    it "leaves creates as config instance" do
      expect(LittleBigAdmin.config).to eq nil
      LittleBigAdmin.setup { |config| }
      expect(LittleBigAdmin.config).to be_instance_of(LittleBigAdmin::Config)
    end


    it "sets the config variables" do
      LittleBigAdmin.setup do |config|
        config.title = "My Awesome Title"
      end

      expect(LittleBigAdmin.config.title).to eq "My Awesome Title"
    end
  end

end
