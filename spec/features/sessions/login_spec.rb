require 'rails_helper'

feature 'Session login', :capy do

  let(:orgn) { FG.create(:org)                                             }
  let(:team) { FG.create(:team, org_id: orgn.id)                           }
  let(:user) { FG.create(:user)                                            }
  let(:mem)  { FG.create(:membership, user: user, team: team, rank: 'ACT') }

  before(:each) { set_host_url(team, orgn) }

  it 'renders /login' do
    visit '/login'
    expect(current_path).to eq('/login')
    expect(page).not_to be_nil
  end

  it 'handles a valid login' do
    visit '/login'
    fill_in 'Username or Email', with: mem.user_name
    fill_in 'Password',  with: 'smso'
    click_button 'Log In'
    expect(page).not_to be_nil
    expect(page).to have_content user.user_name
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
    page.find('#navDrop').click()
    expect(page).to have_content 'log out'
    click_link 'log out'
    expect(page).not_to have_content lcl_user.user_name
  end
end