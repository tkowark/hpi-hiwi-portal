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

describe JobOffersController do

  # This should return the minimal set of attributes required to create a valid
  # JobOffer. As you add validations to JobOffer, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "title"=>"Open HPI Job", "description" => "MyString", "chair" => "SWA", "start_date" => DateTime.new(2013,11,1),
                        "time_effort" => 3.5, "compensation" => 10.30 } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # JobOffersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all job_offers as @job_offers" do
      job_offer = JobOffer.create! valid_attributes
      get :index, {}, valid_session
      assigns(:job_offers).should eq([job_offer])
    end
  end

  describe "GET show" do
    it "assigns the requested job_offer as @job_offer" do
      job_offer = JobOffer.create! valid_attributes
      get :show, {:id => job_offer.to_param}, valid_session
      assigns(:job_offer).should eq(job_offer)
    end
  end

  describe "GET new" do
    it "assigns a new job_offer as @job_offer" do
      get :new, {}, valid_session
      assigns(:job_offer).should be_a_new(JobOffer)
    end
  end

  describe "GET edit" do
    it "assigns the requested job_offer as @job_offer" do
      job_offer = JobOffer.create! valid_attributes
      get :edit, {:id => job_offer.to_param}, valid_session
      assigns(:job_offer).should eq(job_offer)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new JobOffer" do
        expect {
          post :create, {:job_offer => valid_attributes}, valid_session
        }.to change(JobOffer, :count).by(1)
      end

      it "assigns a newly created job_offer as @job_offer" do
        post :create, {:job_offer => valid_attributes}, valid_session
        assigns(:job_offer).should be_a(JobOffer)
        assigns(:job_offer).should be_persisted
      end

      it "redirects to the created job_offer" do
        post :create, {:job_offer => valid_attributes}, valid_session
        response.should redirect_to(JobOffer.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved job_offer as @job_offer" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        post :create, {:job_offer => { "description" => "invalid value" }}, valid_session
        assigns(:job_offer).should be_a_new(JobOffer)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        post :create, {:job_offer => { "description" => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested job_offer" do
        job_offer = JobOffer.create! valid_attributes
        # Assuming there are no other job_offers in the database, this
        # specifies that the JobOffer created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        JobOffer.any_instance.should_receive(:update).with({ "description" => "MyString" })
        put :update, {:id => job_offer.to_param, :job_offer => { "description" => "MyString" }}, valid_session
      end

      it "assigns the requested job_offer as @job_offer" do
        job_offer = JobOffer.create! valid_attributes
        put :update, {:id => job_offer.to_param, :job_offer => valid_attributes}, valid_session
        assigns(:job_offer).should eq(job_offer)
      end

      it "redirects to the job_offer" do
        job_offer = JobOffer.create! valid_attributes
        put :update, {:id => job_offer.to_param, :job_offer => valid_attributes}, valid_session
        response.should redirect_to(job_offer)
      end
    end

    describe "with invalid params" do
      it "assigns the job_offer as @job_offer" do
        job_offer = JobOffer.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        put :update, {:id => job_offer.to_param, :job_offer => { "description" => "invalid value" }}, valid_session
        assigns(:job_offer).should eq(job_offer)
      end

      it "re-renders the 'edit' template" do
        job_offer = JobOffer.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        JobOffer.any_instance.stub(:save).and_return(false)
        put :update, {:id => job_offer.to_param, :job_offer => { "description" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested job_offer" do
      job_offer = JobOffer.create! valid_attributes
      expect {
        delete :destroy, {:id => job_offer.to_param}, valid_session
      }.to change(JobOffer, :count).by(-1)
    end

    it "redirects to the job_offers list" do
      job_offer = JobOffer.create! valid_attributes
      delete :destroy, {:id => job_offer.to_param}, valid_session
      response.should redirect_to(job_offers_url)
    end
  end

end
