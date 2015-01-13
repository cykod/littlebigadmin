require "spec_helper"

describe "Rendering View Helper", type: :request do

  before do
    visit little_big_admin.admin_page_path("dashboard")
  end

  it "renders the panel titles" do
    expect(page).to have_content("Something A")
    expect(page).to have_content("Something B")
  end

  it "renders partial in one panel" do
    expect(page).to have_content("Here's a test")
  end
end
