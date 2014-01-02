require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

describe ChairsController do

  let(:deputy) { FactoryGirl.create(:user) }

  let(:admin) { FactoryGirl.create(:role, name: 'Admin') }

  # This should return the minimal set of attributes required to create a valid
  # Chair. As you add validations to Chair, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "name" => "HCI", "description" => "Human Computer Interaction", 
      "head_of_chair" => "Prof. Patrick Baudisch" , "deputy_id" => deputy.id } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ChairsController. Be sure to keep this updated too.
  login_user FactoryGirl.create(:role, name: 'Admin')

  describe "GET index" do
    it "assigns all chairs as @chairs" do
      chair = Chair.create! valid_attributes
      get :index, {}
      assigns(:chairs).should eq([chair])
    end
  end

  describe "GET show" do

    it "assigns the requested chair as @chair" do
      chair = Chair.create! valid_attributes
      get :show, {:id => chair.to_param}
      assigns(:chair).should eq(chair)
    end
  end

  describe "GET new" do
    it "assigns a new chair as @chair" do
      get :new, {}
      assigns(:chair).should be_a_new(Chair)
    end
  end

  describe "GET edit" do
    it "assigns the requested chair as @chair" do
      chair = Chair.create! valid_attributes
      get :edit, {:id => chair.to_param}
      assigns(:chair).should eq(chair)
    end
  end

  describe "POST create" do
    describe "with valid params" do

      it "creates a new Chair" do
        expect {
          post :create, {:chair => valid_attributes}
        }.to change(Chair, :count).by(1)
      end

      it "assigns a newly created chair as @chair" do

        post :create, {:chair => valid_attributes}
        assigns(:chair).should be_a(Chair)
        assigns(:chair).should be_persisted
      end

      it "redirects to the created chair" do
        post :create, {:chair => valid_attributes}
        response.should redirect_to(Chair.last)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested chair" do
        chair = Chair.create! valid_attributes
        # Assuming there are no other chairs in the database, this
        # specifies that the Chair created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Chair.any_instance.should_receive(:update).with({ "name" => "HCI", "description" => "Human Computer Interaction", 
              "head_of_chair" => "Prof. Patrick Baudisch", "deputy_id" => deputy.id.to_s })
        put :update, {:id => chair.to_param, :chair => { "name" => "HCI", "description" => "Human Computer Interaction", 
              "head_of_chair" => "Prof. Patrick Baudisch", "deputy_id" => deputy.id }}
      end

      it "assigns the requested chair as @chair" do
        chair = Chair.create! valid_attributes
        put :update, {:id => chair.to_param, :chair => valid_attributes}
        assigns(:chair).should eq(chair)
      end

      it "redirects to the chair" do
        chair = Chair.create! valid_attributes
        put :update, {:id => chair.to_param, :chair => valid_attributes}
        response.should redirect_to(chair)
      end
    end

  end

end
