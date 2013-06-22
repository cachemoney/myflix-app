shared_examples "require_sign_in" do
	it "redirects to the sign_in_path" do
		clear_current_user
		action
		expect(response).to redirect_to sign_in_path
	end
end

shared_examples "require_admin" do
	it "redirects to the home path" do
		session[:user_id] = Fabricate(:user)
		action
		expect(response).to redirect_to home_path
	end
end