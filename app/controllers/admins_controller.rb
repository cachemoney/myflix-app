class AdminsController < AuthenticatedController
	before_filter :require_admin

	def require_admin
		redirect_to root_path, flash: { error: "You do not have access here" } unless current_user.admin?
	end
end