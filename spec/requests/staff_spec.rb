require 'spec_helper'

describe "Staff" do
  describe "GET /staff" do
  	let(:admin_role) { FactoryGirl.create(:role, name: 'Admin', level: 3) }
 	let(:admin) { FactoryGirl.create(:user, role: admin_role) }

    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      login_as(admin, :scope => :user)
      get staff_index_path
      response.status.should be(200)
    end
  end
end