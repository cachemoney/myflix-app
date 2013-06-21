# encoding: utf-8

class SmallCoverUploader < CarrierWave::Uploader::Base

  storage :fog
  include CarrierWave::MimeTypes
  process :set_content_type

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}"
  end


  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
