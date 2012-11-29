require 'spec_helper'

describe CanBe::ModelExtensions do
  context "instance methods" do
    describe "boolean record methods" do
      it "are created" do
        rec = new_address
        rec.should respond_to :home_address?
        rec.should respond_to :work_address?
      end

      it "responds true" do
        new_address(:home_address).should be_home_address
        new_address(:work_address).should be_work_address
      end

      it "responds false" do
        new_address(:work_address).should_not be_home_address
      end
    end

    describe "change_to methods" do
      it "are created" do
        rec = new_address
        rec.should respond_to :change_to_home_address
        rec.should respond_to :change_to_work_address
      end

      it "updates the record" do
        rec = new_address(:work_address)
        rec.change_to_home_address
        rec.should be_home_address
      end

      it "does not update the database" do
        rec = create_address(:work_address)
        rec.change_to_home_address
        Address.first.should_not be_home_address
      end
    end

    describe "change_to! methods" do
      it "are created" do
        rec = create_address
        rec.should respond_to :change_to_home_address!
        rec.should respond_to :change_to_work_address!
      end

      it "updates the record" do
        rec = create_address(:work_address)
        rec.change_to_home_address!
        rec.should be_home_address
      end

      it "updates the database" do
        rec = create_address(:work_address)
        rec.change_to_home_address!
        Address.first.should be_home_address
      end
    end
  end

  context "class methods" do
    describe "create methods" do
      it "are created" do
        Address.should respond_to :create_home_address
        Address.should respond_to :create_work_address
      end

      it "create the records in the database" do
        a = Address.create_home_address
        Address.find(a.id).should be_home_address

        a = Address.create_work_address
        Address.find(a.id).should be_work_address
      end

      it "creates the records changing to the correct type" do
        a = Address.create_home_address can_be_type: 'work_address'
        Address.find(a.id).should be_home_address
      end
    end

    describe "new methods" do
      it "are created" do
        Address.should respond_to :new_home_address
        Address.should respond_to :new_work_address
      end

      it "create the correct type" do
        Address.new_home_address.should be_home_address
        Address.new_work_address.should be_work_address
      end

      it "create the records changing to the correct type" do
        Address.create_home_address(can_be_type: 'work_address').should be_home_address
      end

      it "don't create the records in the database" do
        Address.new_home_address
        Address.new_work_address
        Address.count.should == 0
      end
    end

    describe "finder methods" do
      let(:home_count) { 5 }
      let(:work_count) { 4 }
      let(:vacation_count) { 3 }

      before :each do
        home_count.times { Address.create_home_address }
        work_count.times { Address.create_work_address }
        vacation_count.times { Address.create_vacation_address }
      end

      it "are created" do
        Address.should respond_to :find_by_can_be_types
        Address.should respond_to 'home_address'.pluralize
        Address.should respond_to 'work_address'.pluralize
      end

      it "#find_by_can_be_types returns the correct records" do
        recs = Address.find_by_can_be_types(:home_address, :work_address)
        recs.should have(home_count + work_count).items
        recs.each do |a|
          a.can_be_type.should =~ /^home_address|work_address$/
        end
      end

      it "returns the correct records" do
        recs = Address.home_addresses
        recs.should have(home_count).items
        recs.each { |a| a.should be_home_address }

        recs = Address.work_addresses
        recs.should have(work_count).items
        recs.each { |a| a.should be_work_address }
      end
    end
  end

  context "default type" do
    it "uses the first type as the default" do
      Address.new.should be_home_address
    end

    it "uses the specified default_type option" do
      Person.new.should be_female
    end
  end

  context "database field" do
    it "uses the :can_be_type field (default)" do
      Address.new_home_address.can_be_type.should == 'home_address'
    end

    it "uses the specified field" do
      Person.new_female.gender.should == 'female'
    end
  end

  context "validity of type value" do
    it "should be valid" do
      Address.new_home_address.should be_valid
      Address.new_work_address.should be_valid
    end

    it "should not be valid" do
      Address.new(can_be_type: 'invalid type').should_not be_valid
    end
  end
end
