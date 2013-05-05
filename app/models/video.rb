class Video < ActiveRecord::Base
  attr_accessible :description, :large_cover_url, :small_cover_url, :title
end
