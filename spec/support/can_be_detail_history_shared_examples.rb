shared_examples "it is a details model with history" do
  context "unattached details records" do
    it "finds the correct can_be record" do
      u = HistoryUpload.create_video_upload
      u.change_to_image_upload!
      HistoryVideoUploadDetail.first.history_upload.should == u
    end

    it "finds the correct can_be record given duplicate id's" do
      u1 = HistoryUpload.create_video_upload
      u2 = HistoryUpload.create_image_upload
      u1.change_to_image_upload!
      u2.change_to_video_upload!
      HistoryImageUploadDetail.first.history_upload.should == u2
    end
  end
end
