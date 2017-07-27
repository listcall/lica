require 'rails_helper'

describe 'Session membership', :capy do

  include_context "Integration Environment"

  before(:each) { set_feature_host(team1) }

  context 'when logging into the account domain' do
    context 'with no team memberships' do
      it 'shows no team names' do
        capy_user_login
        page.find('#navDrop-user').click()
        expect(page).to     have_selector('ul#userDrop li:nth-child(1)')
        expect(page).to     have_selector('ul#userDrop li:nth-child(2)')
        expect(page).not_to have_selector('ul#userDrop li:nth-child(6)')
        expect(all('#userDrop li').count).to eq(5)
      end
    end

    context 'with one team membership' do
      it 'shows one team name' do
        login_with mem1
        page.find('#navDrop-user').click()
        expect(page).to     have_selector('ul#userDrop li:nth-child(1)')
        expect(page).to     have_selector('ul#userDrop li:nth-child(2)')
        expect(all('#userDrop li').count).to eq(5)
      end
    end
  end

  it 'handles logout via button' do
    login_with mem1
    expect(page).to have_content usr1.user_name
    page.find('#navDrop-user').click()
    expect(page).to have_content 'Log out'
    click_link 'Log out'
    expect(page).to_not have_content usr1.user_name
  end
end
