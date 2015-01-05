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
      output = builder.render
      expect(output).to include "<div class=\"grid-2\">"
      expect(output).to include "<div class=\"span-1\">"
    end

    it "allows sizing to control grid and span" do
      builder.grid do
        block :div, size: 3
        block :div
      end
      output = builder.render
      expect(output).to include "<div class=\"grid-4\">"
      expect(output).to include "<div class=\"span-3\">"
      expect(output).to include "<div class=\"span-1\">"
    end
  end

end
