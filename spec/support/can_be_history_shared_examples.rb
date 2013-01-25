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

    it "stores the additional history record when changing the type" do
      u = HistoryUpload.create_image_upload
      u.change_to_video_upload!
      HistoryUploadHistoryRecord.count.should == 2
      h = HistoryUploadHistoryRecord.last
      h.can_be_model_id.should == u.id
      h.can_be_type.should == u.can_be_type
      h.can_be_details_id.should == u.details.id
    end

    it "doesn't store an additional history record when changing back to the original type" do
      u = HistoryUpload.create_image_upload
      u.change_to_video_upload
      u.save
      u.change_to_image_upload!
      HistoryUploadHistoryRecord.count.should == 2
    end
  end

  # TODO: allow force of change methods to delete the details even though they are storing history
  # TODO: Make sure that all history records and details get deletes when storing history
  # TODO: Make sure that any details records can get back to the original records when storing history
end
