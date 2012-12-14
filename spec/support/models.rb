require 'active_record'

load File.dirname(__FILE__) + '/schema.rb'

# The Address model will use the default options
class Address < ActiveRecord::Base
  can_be :home_address, :work_address, :vacation_address
end

class Person < ActiveRecord::Base
  can_be :male, :female, field_name: :gender, default_type: :female
end

class Upload < ActiveRecord::Base
  can_be :image_upload, :video_upload, :thumbnail_upload, :document_upload, :pdf_upload
end

class ImageUploadDetail < ActiveRecord::Base
  can_be_detail :upload, :image_upload
end

class VideoUploadDetail < ActiveRecord::Base
  can_be_detail :upload, :video_upload
end

class ThumbnailUploadDetail < ActiveRecord::Base
end

class DocumentUploadDetail
end

class ConfigSpecModel < ActiveRecord::Base
  can_be :type1, :type2
end

class ConfigSpecDetail < ActiveRecord::Base
end

class ConfigSpecDetail2 < ActiveRecord::Base
end
