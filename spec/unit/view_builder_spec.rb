require "spec_helper"

describe LittleBigAdmin::ViewBuilder do

  let(:builder) { LittleBigAdmin::ViewBuilder.new }

  describe "#grid" do
    it "outputs a stright div tag by default" do
      builder.grid
      expect(builder.render).to eq "<div></div>"
    end

    it "outputs a grid with nested elements" do
      builder.grid do
        block :div
        block :div
      end
      expect(builder.render).to include "<div class=\"grid-2\">"
    end
  end

end
