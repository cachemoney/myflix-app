shared_examples "require_sign_in" do
	clear_current_user
	action
	response.should redirect_to sign_in_path
end