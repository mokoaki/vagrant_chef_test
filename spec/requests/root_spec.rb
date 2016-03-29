require 'rails_helper'

feature 'root page' do
  before(:each) do
    User.create(name: 'test')
    visit root_path
  end

  scenario 'title is title' do
    expect(page).to have_title 'title'
  end

  scenario 'title is sample after click', js: true do
    first("button#test_button").click
    expect(page).to have_title 'sample'
  end
end
