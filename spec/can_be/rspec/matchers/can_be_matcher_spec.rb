require 'spec_helper'

describe "CanBe::RSpec::Matchers::CanBeMatcher" do
  it "doesn't match that can_be is implemented if a list of types isn't provided" do
    Address.should_not implement_can_be
  end

  it "matches with a list of can_be types" do
    Address.should implement_can_be(:home_address, :work_address, :vacation_address)
  end

  it "doesn't match with an incorrect list of can_be types" do
    Address.should_not implement_can_be(:home, :work, :vacation)
  end

  it "matches with a list of can_be types out of order" do
    Address.should implement_can_be(:vacation_address, :work_address, :home_address)
  end

  it "matches when the default type is specified" do
    Person.should implement_can_be(:male, :female).with_default_type(:female)
  end

  it "doesn't match with an incorrect default type" do
    Person.should_not implement_can_be(:male, :female).with_default_type(:male)
  end

  it "matches when the field name is specified" do
    Person.should implement_can_be(:male, :female).with_field_name(:gender)
  end

  it "doesn't match when the field name is incorrect" do
    Person.should_not implement_can_be(:male, :female).with_field_name(:not_gender)
  end

  it "matches when the details name is specified" do
    CustomUpload.should implement_can_be(:image_upload, :video_upload, :thumbnail_upload, :document_upload, :pdf_upload)
                          .with_details_name(:custom_details)
  end

  it "doesn't match when the details name is incorrect" do
    CustomUpload.should_not implement_can_be(:image_upload, :video_upload, :thumbnail_upload, :document_upload, :pdf_upload)
                              .with_details_name(:custom_details_that_is_in_correct)
  end

  it "matches when the details models are specified" do
    CustomUpload.should implement_can_be(:image_upload, :video_upload, :thumbnail_upload, :document_upload, :pdf_upload)
                          .and_has_details(:image_upload, :custom_image_upload_detail)
                          .and_has_details(:video_upload, :custom_video_upload_detail)
  end

  it "doesn't match when the details models are incorrect" do
    CustomUpload.should_not implement_can_be(:image_upload, :video_upload, :thumbnail_upload, :document_upload, :pdf_upload)
                              .and_has_details(:image_uploads, :custom_image_upload_detail)
                              .and_has_details(:video_uploads, :custom_video_upload_detail)
  end
end
