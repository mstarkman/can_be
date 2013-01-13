shared_examples "it is a details model" do |can_be_class, image_class|
  it "implements has_one to the can_be model" do
    u = can_be_class.create_image_upload
    image_class.first.send(can_be_class.name.underscore).should == u
  end

  it "deletes the can_be model" do
    can_be_class.create_image_upload
    can_be_class.count.should == 1
    image_class.first.destroy
    can_be_class.count.should == 0
  end
end
