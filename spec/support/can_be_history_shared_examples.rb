shared_examples "it has history" do
  context "details models" do
    it "doesn't delete the details record after changing the can_be type" do
      u = HistoryUpload.create_image_upload
      u.change_to_video_upload!
      HistoryImageUploadDetail.count.should == 1
      HistoryVideoUploadDetail.count.should == 1
    end

    it "doesn't create additional details records when switching the types back and forth" do
      u = HistoryUpload.create_image_upload
      u.change_to_video_upload!
      u.change_to_image_upload!
      HistoryImageUploadDetail.count.should == 1
      HistoryVideoUploadDetail.count.should == 1
    end

    it "sets the details to the original value when swtiching the type back" do
      u = HistoryUpload.create_image_upload
      u.change_to_video_upload!
      u.change_to_image_upload!
      u.details.should == HistoryImageUploadDetail.first
    end
  end

  context "history model" do
    it "stores a history record after creation in the history model" do
      u = HistoryUpload.create_image_upload
      HistoryUploadHistoryRecord.count.should == 1
    end

    it "stores a history record after new and save in the history model" do
      u = HistoryUpload.new_image_upload
      u.save
      HistoryUploadHistoryRecord.count.should == 1
    end

    it "stores the correct information in the history table" do
      u = HistoryUpload.create_image_upload
      h = HistoryUploadHistoryRecord.first
      h.can_be_model_id.should == u.id
      h.can_be_type.should == u.can_be_type
      h.can_be_details_id.should == u.details.id
    end

    context "history fields" do
      before :each do
        @u = HistoryUpload.create_image_upload
        @u.change_to_video_upload!
        HistoryUploadHistoryRecord.count.should == 2
        @h = HistoryUploadHistoryRecord.last
      end

      it "stores the correct can_be_model_id value" do
        @h.can_be_model_id.should == @u.id
      end

      it "stores the correct can_be_type value" do
        @h.can_be_type.should == @u.can_be_type
      end

      it "stores the correct can_be_details_id value" do
        @h.can_be_details_id.should == @u.details.id
      end

      it "stores the correct can_be_details_type" do
        @h.can_be_details_type.should == HistoryVideoUploadDetail.name.underscore.to_s
      end
    end

    it "doesn't store an additional history record when changing back to the original type" do
      u = HistoryUpload.create_image_upload
      u.change_to_video_upload
      u.save
      u.change_to_image_upload!
      HistoryUploadHistoryRecord.count.should == 2
    end

    context "destroy can_be record" do
      before :each do
        u = HistoryUpload.create_video_upload
        u.change_to_image_upload!
        u.destroy
      end

      it "destroys all details records" do
        HistoryImageUploadDetail.count.should == 0
        HistoryVideoUploadDetail.count.should == 0
      end

      it "destroys all of the history records" do
        HistoryUploadHistoryRecord.count.should == 0
      end
    end
  end

  # TODO: allow force of change methods to delete the details even though they are storing history
  # TODO: calling a change_to (no exclamation) method should remove the old details record when the record is saved
end
