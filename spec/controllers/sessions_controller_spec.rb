require 'spec_helper'

describe SessionsController do

  describe "GET login page" do

    it "should render the login tempate" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'Post #create' do
    let(:user1){ Fabricate(:user) }

    context "with existing user" do
      it "create login session" do
        post :create, email: user1.email, password: "password"
        expect(session[:user_id]).to eq user1.id
      end
      it "redirects to the home page" do
        post :create, email: user1.email,password: "password"
        expect(response).to redirect_to(home_path)
      end
    end
    context "with non-existant user" do
      it " login session not created" do
        post :create, email: "",password:""
        expect(session[:user_id]).to eq nil
      end
      it "redirects to :sign_in page after failed sign-in" do
        post :create, email: "",password: ""
        expect(response).to redirect_to(sign_in_path)
      end
    end
    context "with wrong password" do
      it "doesn't create login session" do
        post :create, email: user1.email,password:"wrong_password"
        expect(session[:user_id]).to eq nil
      end
      it "redirects to the :sign_in page" do
        post :create, email: user1.email,password:"wrong_password"
        expect(response).to redirect_to(sign_in_path)
      end
    end
  end

  describe 'GET destroy' do
    # let(:user1){ Fabricate(:user) }
    # post :create, email: user1.email, password: "qwerty"
    
    context "session destroyed" do
      it "user_id is nil when user visits log_out_path" do
        session[:user_id] = Fabricate(:user).id
        get :destroy
        expect(session[:user_id]).to eq nil
      end
      it "redirects to root path" do
        delete :destroy
        expect(response).to redirect_to(root_path)
      end
    end
  end

end