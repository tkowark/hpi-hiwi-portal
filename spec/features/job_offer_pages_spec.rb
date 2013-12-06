require 'spec_helper'

describe "Job Offer pages" do

  subject { page }
  
  describe "show page" do
    let(:job_offer) { FactoryGirl.create(:joboffer, responsible_user: FactoryGirl.create(:user), status: FactoryGirl.create(:job_status, :name => "open")) }

    before { visit job_offer_path(job_offer) }

    describe "application button and list" do
      let(:student_role) { FactoryGirl.create(:role, name: 'Student', level: 1) }
      let(:research_assistant_role) { FactoryGirl.create(:role, name: 'Research Assistant', level: 2) }
      let(:student) { FactoryGirl.create(:user, role: student_role) }

      describe "without being signed in" do
        it { should_not have_button('Apply') }
        it { should_not have_selector('h4', text: 'Applications') }
      end

      describe "when being a student" do
        before do 
          login_as(student, :scope => :user)
          visit job_offer_path(job_offer)
        end

        it { should have_button('Apply') }
        it { should_not have_selector('h4', text: 'Applications') }

        describe "and having applied already" do
          before do 
            FactoryGirl.create(:application, user: student, job_offer: job_offer)
            login_as(student, :scope => :user)
            visit job_offer_path(job_offer)
          end

          it { should_not have_button('Apply') }
          it { should_not have_selector('h4', text: 'Applications') }
        end
      end

      describe "when being a research assistant" do
        let(:research_assistant) { FactoryGirl.create(:user, role: research_assistant_role, chair: job_offer.chair) }

        before do
          FactoryGirl.create(:application, job_offer: job_offer)
          login_as(research_assistant, :scope => :user)
          visit job_offer_path(job_offer)
        end

        it { should_not have_button('Apply') }
        it { should have_selector('h4', text: 'Applications') }

        it { should have_button('Accept') }
        it { should have_button('Decline') }

        it "is possible to mark a job as completed" do
          should have_link 'Job completed'

          visit edit_job_offer_path(job_offer)
          should have_link 'Job completed'
        end
        
      end
    end
  end
end