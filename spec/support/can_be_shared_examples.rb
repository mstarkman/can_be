shared_examples "it has details" do |can_be_class, image_class, video_class, details_name = :details|
  context "details" do
    context "persistence" do
      it "persists the details information to the database (create method)" do
        upload = can_be_class.create
        upload.send(details_name).format = "jpeg"
        upload.save
        image_class.first.format.should == "jpeg"
      end

      it "persists the details information to the database (create_image_upload method)" do
        upload = can_be_class.create_image_upload
        upload.send(details_name).format = "jpeg"
        upload.save
        image_class.first.format.should == "jpeg"
      end

      it "persists the details information to the database (new method)" do
        upload = can_be_class.new
        upload.send(details_name).format = "jpeg"
        upload.save
        image_class.first.format.should == "jpeg"
      end

      it "persists the details information to the database (new_image_upload method)" do
        upload = can_be_class.new_image_upload
        upload.send(details_name).format = "jpeg"
        upload.save
        image_class.first.format.should == "jpeg"
      end

      it "persists only one details record" do
        upload = can_be_class.new
        upload.send(details_name).format = "jpeg"
        upload.save
        found_upload = can_be_class.find(upload.id)
        found_upload.send(details_name).format.should == "jpeg"
        found_upload.save
        image_class.count.should == 1
      end

      it "deletes the details record" do
        u = can_be_class.create_image_upload
        image_class.count.should == 1
        u.destroy
        image_class.count.should == 0
      end
    end

    context "create method" do
      it "creates the correct details record" do
        can_be_class.create_image_upload.send(details_name).should be_instance_of(image_class)
        can_be_class.create_video_upload.send(details_name).should be_instance_of(video_class)
      end

      it "doesn't create details record if model doesn't call #can_be_detail" do
        can_be_class.create_thumbnail_upload.send(details_name).should be_nil
      end

      it "doesn't create details record if model doesn't exist" do
        can_be_class.create_pdf_upload.send(details_name).should be_nil
      end

      it "doesn't create details record unless an ActiveRecord model" do
        can_be_class.create_document_upload.send(details_name).should be_nil
      end

      it "persists the details record to the database" do
        can_be_class.create_image_upload
        image_class.count.should == 1
      end
    end

    context "new method" do
      it "instantiates the correct details record" do
        can_be_class.new_image_upload.send(details_name).should be_instance_of(image_class)
        can_be_class.new_video_upload.send(details_name).should be_instance_of(video_class)
      end

      it "doesn't instantiate details record if model doesn't call #can_be_detail" do
        can_be_class.new_thumbnail_upload.send(details_name).should be_nil
      end

      it "doesn't instantiate details record if model doesn't exist" do
        can_be_class.new_pdf_upload.send(details_name).should be_nil
      end

      it "doesn't instantiate details record unless an ActiveRecord model" do
        can_be_class.new_document_upload.send(details_name).should be_nil
      end

      it "doesn't persist the details record to the database" do
        can_be_class.new_image_upload
        image_class.count.should == 0
      end
    end

    context "change type via #change_to" do
      it "changes the details record type" do
        u = can_be_class.new_image_upload
        u.change_to_video_upload
        u.send(details_name).should be_instance_of(video_class)
      end

      it "changes the details to nil" do
        u = can_be_class.new_image_upload
        u.change_to_thumbnail_upload
        u.send(details_name).should be_nil
      end

      it "doesn't create a new record in the database" do
        u = can_be_class.new_image_upload
        u.change_to_video_upload
        image_class.count.should == 0
        video_class.count.should == 0
      end

      it "has access to the original details if not saved" do
        u = can_be_class.create_image_upload
        u.change_to_video_upload
        can_be_class.find(u.id).send(details_name).should be_instance_of(image_class)
      end

      it "allows for items to be set on the new details records" do
        new_encoding = "new encoding"
        u = can_be_class.new_image_upload
        u.change_to_video_upload do |details|
          details.encoding = new_encoding
        end
        u.send(details_name).encoding.should == new_encoding
      end
    end

    context "change type via #change_to!" do
      it "changes the details record type" do
        u = can_be_class.create_video_upload
        u.change_to_image_upload!
        can_be_class.find(u.id).send(details_name).should be_instance_of(image_class)
      end

      it "changes the details to nil" do
        u = can_be_class.create_image_upload
        u.change_to_thumbnail_upload!
        can_be_class.find(u.id).send(details_name).should be_nil
      end

      it "doesn't create a new record in the database" do
        u = can_be_class.create_video_upload
        u.change_to_image_upload!
        image_class.count.should == 1
      end

      it "removes the old database record from the database" do
        u = can_be_class.create_image_upload
        u.change_to_video_upload!
        image_class.count.should == 0
      end

      it "allows for items to be set on the new details records" do
        new_format = "new format"
        u = can_be_class.create_video_upload
        u.change_to_image_upload! do |details|
          details.format = new_format
        end
        can_be_class.find(u.id).send(details_name).format.should == new_format
      end
    end

    context "change type setting the model attribute" do
      it "changes the details record type" do
        u = can_be_class.new_image_upload
        u.can_be_type = "video_upload"
        u.send(details_name).should be_instance_of(video_class)
      end

      it "changes the details to nil" do
        u = can_be_class.new_image_upload
        u.can_be_type = "thumbnail_upload"
        u.send(details_name).should be_nil
      end

      it "doesn't create a new record in the database" do
        u = can_be_class.new_image_upload
        u.can_be_type = "video_upload"
        image_class.count.should == 0
        video_class.count.should == 0
      end

      it "has access to the original details if not saved" do
        u = can_be_class.create_image_upload
        u.can_be_type = "video_upload"
        can_be_class.find(u.id).send(details_name).should be_instance_of(image_class)
      end
    end
  end
end
