require 'spec_helper'

describe "CanBe::RSpec::Matchers::CanBeDetailMatcher" do
  it "matches when the correct can_be model is passed" do
    VideoUploadDetail.should implement_can_be_detail(:upload)
  end

  it "matches when the correct can_be model and details_name are passed" do
    CustomVideoUploadDetail.should implement_can_be_detail(:custom_upload, :custom_details)
  end
end
