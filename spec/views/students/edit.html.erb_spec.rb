require 'rails_helper'

describe "students/edit" do
  before(:each) do
    @student = assign(:student, FactoryBot.create(:student))
  end

  it "renders the edit student form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", student_path(@student.id), "post" do
      assert_select "select#student_birthday_1i[name=?]", "student[birthday(1i)]"
      assert_select "select#student_birthday_2i[name=?]", "student[birthday(2i)]"
      assert_select "select#student_birthday_3i[name=?]", "student[birthday(3i)]"
      assert_select "input#student_semester[name=?]", "student[semester]"
      assert_select "select#academic_program_id[name=?]", "student[academic_program_id]"
      assert_select "select#graduation_id[name=?]", "student[graduation_id]"
      assert_select "textarea#student_additional_information[name=?]", "student[additional_information]"
      assert_select "input#student_homepage[name=?]", "student[homepage]"
      assert_select "input#student_github[name=?]", "student[github]"
      assert_select "input#student_facebook[name=?]", "student[facebook]"
      assert_select "input#student_xing[name=?]", "student[xing]"
      assert_select "input#student_linkedin[name=?]", "student[linkedin]"
    end
  end
end
