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

  scenario 'User creates a person', js: true do
    visit '/'
    fill_in "First Name:", with: "Joe"
    fill_in "Last Name:", with: "Example"
    fill_in "Address:", with: "15 Main St"
    click_button "Create Person"

    expect(page).to have_content("Joe Example")
    expect(page).to have_content("15 Main St")
  end

  scenario 'User tries to create a person with incomplete data', js: true do
    visit '/'
    click_button "Create Person"
    expect(page).to have_content("First name can't be blank")

    fill_in "First Name:", with: "Joe"
    fill_in "Last Name:", with: "Example"
    click_button "Create Person"

    expect(page).to have_no_content("First name can't be blank")
  end

  scenario 'User updates a person', js: true do
    Person.create!(
      first_name: "Joe",
      last_name: "Example",
      address: "15 Main St"
    )

    visit '/'
    expect(page).to have_content("Joe Example")

    click_on "edit"
    within ".person-edit" do
      fill_in "First Name:", with: "Joeeeeey"
      fill_in "Last Name:", with: "Outstanding"
      click_on "Update Person"
    end

    expect(page).to have_content("Joeeeeey Outstanding")
    expect(page).to have_no_content("Joe Example")

    visit page.current_url
    expect(page).to have_content("Joeeeeey Outstanding")
    expect(page).to have_no_content("Joe Example")
  end

  scenario 'User tries to update a person with incomplete data', js: true do
    Person.create!(
      first_name: "Joe",
      last_name: "Example",
      address: "15 Main St"
    )

    visit '/'
    expect(page).to have_content("Joe Example")

    click_on "edit"
    within ".person-edit" do
      fill_in "First Name:", with: ""
      fill_in "Last Name:", with: ""
      click_on "Update Person"
    end

    within ".person-edit" do
      expect(page).to have_content("First name can't be blank")
    end
  end

end