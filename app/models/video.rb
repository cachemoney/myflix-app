require 'carrierwave/orm/activerecord'
class Video < ActiveRecord::Base
  belongs_to	:category
  has_many	:reviews, order: "created_at DESC"
  has_many	:queue_items
  mount_uploader :large_cover_url, LargeCoverUploader
  mount_uploader :small_cover_url, SmallCoverUploader
  
  validates :title, :description, presence: true

  def self.search_by_title(search_term)
  	return [] if search_term.blank?
  	where("title LIKE ?", "%#{ search_term}%").order("created_at DESC")
	end

  def rating
    reviews.average(:rating).round(1) if reviews.average(:rating)
  end

end
