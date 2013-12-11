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
  let(:chair) { FactoryGirl.create(:chair, name: "Chair") }
  let(:valid_attributes) {{ "title"=>"Open HPI Job", "description" => "MyString", "chair_id" => chair.id, "start_date" => Date.new(2013,11,1),
                        "time_effort" => 3.5, "compensation" => 10.30} }
  let(:valid_attributes_with_status) {{"title"=>"Open HPI Job", "description" => "MyString", "chair_id" => chair.id, "start_date" => Date.new(2013,11,1),
                        "time_effort" => 3.5, "compensation" => 10.30, "status" => "completed"}}

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # JobOffersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before(:each) do
      @epic = FactoryGirl.create(:chair, name:"EPIC")
      @os = FactoryGirl.create(:chair, name:"OS and Middleware")
      @itas = FactoryGirl.create(:chair, name:"Internet and Systems Technologies")
  end

  describe "Check if views are rendered" do
        render_views

    it "renders the find results" do
      job_offer = JobOffer.create! valid_attributes
      get :find, ({:chair => @epic.id}), valid_session
      response.should render_template("index")
  end

    it "renders the archive" do
      job_offer = JobOffer.create! valid_attributes
      get :archive, {}, valid_session
    response.should render_template("archive")
  end

    it "renders the jobs found archive" do
      job_offer = JobOffer.create! valid_attributes
      get :find_archived_jobs, ({:chair => @epic.id}), valid_session
      response.should render_template("archive")
  end
end

  describe "GET index" do
    it "assigns all job_offers as @job_offer-list[:items]" do
      job_offer = JobOffer.create! valid_attributes
      get :index, {}, valid_session
      assigns(:job_offers_list)[0][:items].should eq([job_offer])
    end
  end

  describe "GET archive" do
    it "assigns all archive job_offers as @job_offerlist[:items]" do
      job_offer = JobOffer.create! valid_attributes_with_status
      get :archive, {}, valid_session
      assigns(:job_offers_list)[0][:items].should eq([job_offer])
    end

    it "does not assign non-completed jobs" do
      job_offer = JobOffer.create! valid_attributes
      get :archive, {}, valid_session
      assert assigns(:job_offers_list)[0][:items].empty?
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

    it "only allows the responsible user to edit" do
      job_offer = JobOffer.create! valid_attributes
      job_offer.responsible_user = FactoryGirl.create(:user)
      job_offer.save
      get :edit, {:id => job_offer.to_param}, valid_session
      response.should redirect_to(job_offer)
    end
  end

  describe "GET find" do
    it "assigns @job_offers_list[:items] to all job offers with the chair EPIC" do

      FactoryGirl.create(:joboffer, chair: @itas)
      FactoryGirl.create(:joboffer, chair: @epic)
      FactoryGirl.create(:joboffer, chair: @os)
      FactoryGirl.create(:joboffer, chair: @epic)

      job_offers = JobOffer.find_jobs ({:filter => {:chair => @epic.id}})
      get :find, ({:chair => @epic.id}), valid_session
      assigns(:job_offers_list)[0][:items].to_a.should =~ (job_offers).to_a
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

      it "only allows the responsible user to update" do
        job_offer = JobOffer.create! valid_attributes
        job_offer.responsible_user = FactoryGirl.create(:user)
        job_offer.save
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
