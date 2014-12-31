require "spec_helper"

describe LittleBigAdmin::Base do

  describe ".setting" do
  
    class SettingExerciser < LittleBigAdmin::Base
      setting :basic, "Default Name"

      setting :blocked do 
        # e.g. something_testerama
        (@name.to_s + "_testerama").to_sym
      end

      setting :multiple do 
        [ :like, :this ]
      end

      setting :with_options do
        [ { opt1: "a", opt2: "b" } ]
      end

      setting :procd do
        ->(user) { user.name }
      end

      list_setting :empty_list

      list_setting :list_with_default do
        [ [ :arg1, { opt1: "a" } ],
          [ :arg2 ] ]
      end

    end

    context "Basic" do

      it "saves the default for access in an instance" do
        exerciser = SettingExerciser.new(:something)
        expect(exerciser.basic_value).to eq "Default Name"
      end

      it "allows overriding the name in a setup block" do
        exerciser = SettingExerciser.new(:something) do
          basic "Overridden Name"
        end
        expect(exerciser.basic_value).to eq "Overridden Name"
      end
    end

    context "Blocked" do

      it "allows instance eval'd blocks to set defaults " do
        exerciser = SettingExerciser.new(:something)
        expect(exerciser.blocked_value).to eq :something_testerama
      end

      it "still allows overrides" do
        exerciser = SettingExerciser.new(:something) do
          blocked "Overridden Name"
        end
        expect(exerciser.blocked_value).to eq "Overridden Name"
      end
    end

    context "Multiple args" do
      it "allows more than one default arg to passed to the settings" do
        exerciser = SettingExerciser.new(:something)
        expect(exerciser.multiple_args[0]).to eq :like
        expect(exerciser.multiple_args[1]).to eq :this
      end
    end

    context "Options" do
      it "allows default options to come in via a hash" do
        exerciser = SettingExerciser.new(:something)
        expect(exerciser.with_options_options[:opt1]).to eq "a"
        expect(exerciser.with_options_options[:opt2]).to eq "b"
      end

      it "allows overriding of a single option" do
        exerciser = SettingExerciser.new(:something) do
          with_options opt1: "overridden" 
        end
        expect(exerciser.with_options_options[:opt1]).to eq "overridden"
        expect(exerciser.with_options_options[:opt2]).to eq "b"
      end
    end

    context "With procs as default options" do
      let(:user) { double(:user, name: "Svend") }

      it "sets up the block method" do
        exerciser = SettingExerciser.new(:something)
        expect(exerciser.procd_block.call(user)).to eq "Svend"
      end

      it "allows overriding of the procd method by passing a single block" do
        exerciser = SettingExerciser.new(:something) do
          procd ->(user) { "#{user.name}erama" }
        end

        expect(exerciser.procd_block.call(user)).to eq "Svenderama"
      end

      it "turns blocks into a callable proc" do
        exerciser = SettingExerciser.new(:something) do
          procd do |user| 
            "#{user.name}erama"
          end
        end

        expect(exerciser.procd_block.call(user)).to eq "Svenderama"
      end
    end

    context "List Setting" do 
      it "defaults to the empty array if there are no list settings set up" do
        exerciser = SettingExerciser.new(:something)
        expect(exerciser.empty_list_settings).to eq []
      end

      it "allows multiple calls during setup to add options to the list" do
        exerciser = SettingExerciser.new(:something) do
          empty_list :arg1
          empty_list :arg2
          empty_list :arg3, option: "a"
        end
        expect(exerciser.empty_list_settings[0]).to eq [ :arg1 ]
        expect(exerciser.empty_list_settings[1]).to eq [ :arg2 ]
        expect(exerciser.empty_list_settings[2]).to eq [ :arg3, { option: "a" } ]
      end

      it "runs the default settings if the user doesn't pass any in" do
        exerciser = SettingExerciser.new(:something)
        expect(exerciser.list_with_default_settings[0]).to eq [ :arg1, { opt1: "a" } ]
        expect(exerciser.list_with_default_settings[1]).to eq [ :arg2 ]
      end

      it "doesn't run the default settings if the user passes some in" do
        exerciser = SettingExerciser.new(:something) do
          list_with_default :override_it
        end
        expect(exerciser.list_with_default_settings[0]).to eq [ :override_it ]
        expect(exerciser.list_with_default_settings[1]).to be nil

      end

    end

  end

end
