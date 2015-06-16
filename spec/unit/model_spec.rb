require "spec_helper"

class LittleBigAdminTestModel

  def name
    "Svend"
  end

end

describe LittleBigAdmin::Model do

  describe ".model_settings" do
    
    context "Defaults" do

      let(:model) { LittleBigAdmin::Model.new(:little_big_admin_test_model) }

      it "sets the name value properly" do
        expect(model.name_value).to eq :little_big_admin_test_model
      end

      it "sets the plural name value properly" do
        expect(model.plural_name_value).to eq :little_big_admin_test_models
      end

      it "sets the instance name block properly" do
        instance = LittleBigAdminTestModel.new
        expect(model.instance_name_block.call(instance)).to eq "Svend"
      end

      it "sets the base scope block properly" do
        expect(model.base_scope_block.call).to eq LittleBigAdminTestModel
      end

      it "sets the new_model block properly" do
        expect(model.new_model_block.call).to be_instance_of(LittleBigAdminTestModel)
      end

      it "sets the view all" do
        expect(model.view_settings).to eq [ [ :all ] ]
      end

      it "sets the page blocks to nil by default" do
        expect(model.index_block).to eq nil
        expect(model.show_block).to eq nil
        expect(model.form_block).to eq nil
      end
    end

  end

end
