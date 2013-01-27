require 'active_record'

load File.dirname(__FILE__) + '/schema.rb'

# The Address model will use the default options
class Address < ActiveRecord::Base
  can_be :home_address, :work_address, :vacation_address
end

class Person < ActiveRecord::Base
  can_be :male, :female, field_name: :gender, default_type: :female
end

class BlockOption < ActiveRecord::Base
  can_be :option_1, :option_2 do
    field_name :option_type
    default_type :option_2
  end
end

class Upload < ActiveRecord::Base
  can_be :image_upload, :video_upload, :thumbnail_upload, :document_upload, :pdf_upload do
    add_details_model :image_upload, :image_upload_detail
    add_details_model :video_upload, :video_upload_detail
  end
end

class ImageUploadDetail < ActiveRecord::Base
  can_be_detail :upload
end

class VideoUploadDetail < ActiveRecord::Base
  can_be_detail :upload
end

class ThumbnailUploadDetail < ActiveRecord::Base
end

class DocumentUploadDetail
end

class CustomUpload < ActiveRecord::Base
  can_be :image_upload, :video_upload, :thumbnail_upload, :document_upload, :pdf_upload do
    add_details_model :image_upload, :custom_image_upload_detail
    add_details_model :video_upload, :custom_video_upload_detail
    details_name :custom_details
  end
end

class CustomImageUploadDetail < ActiveRecord::Base
  can_be_detail :custom_upload, :custom_details
end

class CustomVideoUploadDetail < ActiveRecord::Base
  can_be_detail :custom_upload, details_name: :custom_details
end

class CustomThumbnailUploadDetail < ActiveRecord::Base
end

class CustomDocumentUploadDetail
end

class HistoryUpload < ActiveRecord::Base
  can_be :image_upload, :video_upload, :thumbnail_upload, :document_upload, :pdf_upload do
    add_details_model :image_upload, :history_image_upload_detail
    add_details_model :video_upload, :history_video_upload_detail
    keep_history_in :history_upload_history_record
  end
end

class HistoryImageUploadDetail < ActiveRecord::Base
  can_be_detail :history_upload, history_model: :history_upload_history_record
end

class HistoryVideoUploadDetail < ActiveRecord::Base
  can_be_detail :history_upload, history_model: :history_upload_history_record
end

class HistoryThumbnailUploadDetail < ActiveRecord::Base
end

class HistoryDocumentUploadDetail
end

class HistoryUploadHistoryRecord < ActiveRecord::Base
end

class ConfigSpecModel < ActiveRecord::Base
  can_be :type1, :type2
end

class ConfigSpecDetail < ActiveRecord::Base
end

class ConfigSpecDetail2 < ActiveRecord::Base
end
