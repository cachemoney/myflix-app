class QueueItemsController < ApplicationController
	before_filter	:require_user
	
	def index
		@queue_items = current_user.queue_items
	end

	def create
		video = Video.find(params[:video_id])
		video.queue_items.create(user: current_user, 
			position: new_queue_item_position) unless 
			current_user.queue_items.map(&:video).include?(video)
		redirect_to my_queue_path
	end

	def destroy
		deleted_video = QueueItem.find(params[:id])
		deleted_video.destroy
		redirect_to my_queue_path, notice: "You removed #{deleted_video.video.title} from your Queue."
	end

	def update_queue
    begin
      update_queue_items(params[:queue_items])
      current_user.reorder_queue_items
    rescue ActiveRecord::RecordInvalid
      flash[:error] = "Invalid position number!"
    end
    redirect_to my_queue_path
	end
	
  private

  def queue_video(video)
    QueueItem.create(video: video, user: current_user, position: new_queue_item_position) unless current_user_queued_video?(video)
  end

  def new_queue_item_position
    current_user.queue_items.count + 1
  end

  def current_user_queued_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def update_queue_items(data)
    ActiveRecord::Base.transaction do
      data.each do |queue_item_data|
        queue_item = QueueItem.find(queue_item_data["id"])
        queue_item.update_attributes!(position: queue_item_data["position"]) if queue_item.user == current_user
      end
    end
  end	
end