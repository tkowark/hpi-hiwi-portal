require 'spec_helper'

describe EmployersController do

  let(:deputy) { FactoryGirl.create(:user, :staff) }
  let(:admin) { FactoryGirl.create(:role, :admin) }

  let(:valid_attributes) { { "name" => "HCI", "description" => "Human Computer Interaction",
      "head" => "Prof. Patrick Baudisch" , "deputy_id" => deputy.id } }

  let(:false_attributes) { { "name" => "HCI"} }

  login_user FactoryGirl.create(:role, :admin)

  before(:each) do
    FactoryGirl.create(:job_status, :running)
    FactoryGirl.create(:job_status, :open)
    FactoryGirl.create(:job_status, :pending)
  end

  describe "GET index" do
    it "assigns all internal employers as @employers" do
      internal_employer = FactoryGirl.create(:employer)
      external_employer = FactoryGirl.create(:employer, external: true)
      get :index, {}
      assigns(:employers).should eq([internal_employer])
      assigns(:internal).should eq(true)
    end
  end

  describe "GET index_external" do
    it "assigns all external employers as @employers" do
      internal_employer = FactoryGirl.create(:employer)
      external_employer = FactoryGirl.create(:employer, external: true)
      get :index_external, {}
      assigns(:employers).should eq([external_employer])
      assigns(:internal).should eq(false)
    end
  end

  describe "GET show" do

    it "assigns the requested employer as @employer" do
      employer = FactoryGirl.create(:employer)
      get :show, {:id => employer.to_param}
      assigns(:employer).should eq(employer)
    end
  end

  describe "GET new" do
    it "assigns a new employer as @employer" do
      get :new, {}
      assigns(:employer).should be_a_new(Employer)
    end
  end

  describe "GET edit" do
    describe "with sufficient access rights" do
      it "assigns the requested employer as @employer" do
        employer = FactoryGirl.create(:employer)
        get :edit, {:id => employer.to_param}
        assigns(:employer).should eq(employer)
      end
    end

    describe "with insufficient access rights" do
      login_user FactoryGirl.create(:role, :student)

      it "redirects to requested employer" do
        employer = FactoryGirl.create(:employer)
        get :edit, {:id => employer.to_param}
        response.should redirect_to(employers_path)
        flash[:notice].should eql("You are not authorized to access this page.")
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do

      it "creates a new Employer" do
        expect {
          post :create, { employer: valid_attributes}
        }.to change(Employer, :count).by(2)
      end

      it "assigns a newly created employer as @employer" do

        post :create, { employer: valid_attributes }
        assigns(:employer).should be_a(Employer)
        assigns(:employer).should be_persisted
      end

      it "redirects to the created employer" do
        post :create, { employer: valid_attributes }
        response.should redirect_to(Employer.last)
      end
    end

    describe "with invalid params" do

      it "renders new again" do
        post :create, { employer: false_attributes}
        response.should render_template("new")
        flash[:error].should eql("Invalid content.")
      end

      it "does not create a new employer without deputy" do
        post :create, { employer: {"name" => "HCI", "description" => "Human Computer Interaction",
      "head" => "Prof. Patrick Baudisch"}}
        response.should render_template("new")
        flash[:error].should eql("Invalid content.")
      end

    end

    describe "with insufficient access rights" do
      login_user FactoryGirl.create(:role, :student)

      it "redirects to requested employer" do
        employer = FactoryGirl.create(:employer)
        post :create, {:id => employer.to_param}
        response.should redirect_to(employers_path)
        flash[:notice].should eql("You are not authorized to access this page.")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested employer" do
        employer = FactoryGirl.create(:employer)

        Employer.any_instance.should_receive(:update).with({ "name" => "HCI", "description" => "Human Computer Interaction",
              "head" => "Prof. Patrick Baudisch" } )
        put :update, { id: employer.to_param, employer: { "name" => "HCI", "description" => "Human Computer Interaction",
              "head" => "Prof. Patrick Baudisch" } }
      end

      it "assigns the requested employer as @employer" do
        employer = FactoryGirl.create(:employer)
        deputy.update(employer: employer)
        put :update, { id: employer.id, employer: valid_attributes }
        assigns(:employer).should eq(employer)
      end

      it "redirects to the employer" do
        employer = FactoryGirl.create(:employer)
        deputy.update(employer: employer)
        put :update, { id: employer.id, employer: valid_attributes }
        response.should redirect_to(employer)
      end
    end

    describe "with missing permission" do
      login_user FactoryGirl.create(:role, :student)

      it "redirects to the employer index page" do
        employer = FactoryGirl.create(:employer)
        patch :update, { id: employer.id, employer: valid_attributes }
        response.should redirect_to(employers_path)
      end
    end
  end

  describe "PUT update_staff_to_student" do

    it "demotes staff to student" do
      student_role = FactoryGirl.create(:role, :student)
      staff_role = FactoryGirl.create(:role, :staff)
      employer = FactoryGirl.create(:employer)
      staff_member = FactoryGirl.create(:user, :role => staff_role, :employer => employer)
      user = FactoryGirl.create(:user, role: staff_role, :employer => employer)
      sign_in user
      employer.update(:deputy => user)
      put :update_staff, {:user_id => staff_member.to_param, :new_deputy_id => nil, :id => employer.id}
      assert_equal(student_role, User.find(staff_member.id).role)
      assert_equal(nil, User.find(staff_member.id).employer)
    end
  end
end
