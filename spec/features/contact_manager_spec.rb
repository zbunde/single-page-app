require 'rails_helper'

feature 'The one-page contact manager app' do

  scenario 'The homepage loads', js: true do
    visit '/'
    expect(page).to have_title("Contact Manager")
  end

  scenario 'User views existing people', js: true do
    Person.create!(
      first_name: "Joe",
      last_name: "Example",
      address: "15 Main St"
    )

    visit '/'
    within ".person" do
      expect(page).to have_content("Joe Example")
      expect(page).to have_content("15 Main St")
    end
  end

end