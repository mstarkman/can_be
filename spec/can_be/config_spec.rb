require 'spec_helper'

describe CanBe::Config do
  context "#field_name" do
    it "defines a default field name" do
      subject.field_name.should == :can_be_type
    end
  end

  context "#types" do
    it "converts the array to string values" do
      subject.types = [:a, :b, :c]
      subject.types.should == ["a", "b", "c"]
    end
  end

  context "#default_type" do
    before :each do
      subject.types = [:a, :b, :c]
    end

    it "returns the first type by default" do
      subject.default_type.should == "a"
    end
  end

  context "#parse_options" do
    let(:field_name) { :example_field_name }
    let(:default_type) { :example_default_type }

    before :each do
      subject.types = [:a, :b, :c]

      subject.parse_options({
        field_name: field_name,
        default_type: default_type
      })
    end

    it "returns the correct field_name" do
      subject.field_name.should == field_name
    end

    it "returns the correct default_type" do
      subject.default_type.should == default_type.to_s
    end
  end

  context "#add_detail_model" do
    it "adds the detail information" do
      subject.add_details_model :type1, :config_spec_model
      subject.details[:type1].should == :config_spec_model
    end

    it "adds the detail information for a second record" do
      subject.add_details_model :type1, :config_spec_model
      subject.add_details_model :type1, :config_spec_model2
      subject.details[:type1].should == :config_spec_model2
    end
  end
end

