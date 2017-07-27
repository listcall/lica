require 'rails_helper'

feature 'Session login', :capy do

  include_context "Integration Environment"

  before(:each) { set_feature_host(team1) }

  it 'renders /login' do
    visit '/login'
    expect(current_path).to eq('/login')
    expect(page).not_to be_nil
  end

  it 'handles a valid login' do
    visit '/login'
    fill_in 'Username or Email', with: mem1.user_name
    fill_in 'Password',  with: 'smso'
    click_button 'Log In'
    expect(page).not_to be_nil
    expect(page).to have_content usr1.user_name
  end

  it 'handles invalid login' do
    visit '/login'
    fill_in 'Username or Email', with: 'nonsense'
    fill_in 'Password',  with: 'whatever'
    click_button 'Log In'
    expect(current_path).to eq('/sessions')
    expect(page).not_to be_nil
    expect(page).to have_content 'Invalid user name or password'
  end

  it 'handles logout via path' do
    lcl_user = capy_user_login
    expect(page).to have_content lcl_user.user_name
    visit '/logout'
    expect(page).not_to have_content lcl_user.user_name
  end

  it 'handles logout via button' do
    lcl_user = capy_user_login
    expect(page).to have_content lcl_user.user_name
    page.find('#navDrop-user').click()
    expect(page).to have_content 'Log out'
    click_link 'Log out'
    expect(page).not_to have_content lcl_user.user_name
  end
end
