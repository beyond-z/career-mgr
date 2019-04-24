require 'rails_helper'

RSpec.describe Admin::ProfilesController, type: :controller do
  render_views
  
  let(:user) { create :admin_user }
  
  before do 
    sign_in user
  end

  let(:valid_attributes) { {first_name: 'Bob'} }
  let(:invalid_attributes) { {name: ''} }
  let(:valid_session) { {} }

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      get :edit, params: {}, session: valid_session
      expect(response).to be_successful
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      it "updates the first name" do
        new_first_name = "#{user.first_name}x"
        put :update, params: {user: {first_name: new_first_name}}, session: valid_session
        user.reload
        
        expect(user.first_name).to eq(new_first_name)
      end

      it "updates the last name" do
        new_last_name = "#{user.last_name}x"
        put :update, params: {user: {last_name: new_last_name}}, session: valid_session
        user.reload
        
        expect(user.last_name).to eq(new_last_name)
      end

      it "updates the region" do
        region = create :region
        put :update, params: {user: {region_id: region.id}}, session: valid_session
        user.reload
        
        expect(user.region).to eq(region)
      end
    end

    # no invalid params at this time.
    # context "with invalid params" do
    #   it "returns a success response (i.e. to display the 'edit' template)" do
    #     put :update, params: {name: 'something'}, session: valid_session
    #     expect(response).to be_successful
    #   end
    # end
  end
end
