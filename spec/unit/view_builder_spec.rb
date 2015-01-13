require "spec_helper"

describe LittleBigAdmin::ViewBuilder do

  let(:view_context) { LittleBigAdmin::ApplicationController.new.view_context }
  let(:builder) { LittleBigAdmin::ViewBuilder.new(view_context) }

  describe "#grid" do
    it "outputs a stright div tag by default" do
      builder.grid
      expect(builder.build).to eq "<div></div>"
    end

    it "outputs a grid with nested elements" do
      builder.grid do
        block :div
        block :div
      end
      output = builder.build
      expect(output).to include "<div class=\"grid-2\">"
      expect(output).to include "<div class=\"span-1\">"
    end

    it "allows sizing to control grid and span" do
      builder.grid do
        block :div, size: 3
        block :div
      end
      output = builder.build
      expect(output).to include "<div class=\"grid-4\">"
      expect(output).to include "<div class=\"span-3\">"
      expect(output).to include "<div class=\"span-1\">"
    end
  end

end
