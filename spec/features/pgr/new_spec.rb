require 'rails_helper'

feature 'pgr#new' do

  include_context "Integration Environment"

  describe 'page creation' do
    before(:each) do
      set_feature_host(team1)
      expect(pagr1).to be_present
    end

    it 'renders /paging/new' do
      login_with mem1
      visit '/paging/new'
      expect(page.status_code).to be 200
    end

    context 'when sending email to self' do
      before(:each) do
        login_with mem1
        visit '/paging/new'
        check("broadcast_member_recipients_#{mem1.id}")
        uncheck('phoneCheck')
        fill_in 'txtShort', with: Time.now
        click_button 'Send'
        expect(current_path).to eq('/paging')
      end

      it 'generates the right number of outputs' do
        expect(Pgr::Broadcast.count).to eq(1)
        expect(Pgr::Dialog.count).to    eq(1)
        expect(Pgr::Post.count).to      eq(2)
        expect(Pgr::Outbound.count).to  eq(2)
      end
    end

    context 'when sending email to another member' do
      before(:each) do
        x = mem1; y = mem2
        login_with mem1
        visit '/paging/new'
        check("broadcast_member_recipients_#{mem2.id}")
        uncheck('emailCheck')
        fill_in 'txtShort', with: Time.now
        click_button 'Send'
      end

      it 'generates the right number of outputs' do
        expect(Pgr::Broadcast.count).to eq(1)
        expect(Pgr::Dialog.count).to    eq(1)
        expect(Pgr::Post.count).to      eq(1)
        expect(Pgr::Outbound.count).to  eq(2)
      end
    end

    context 'when sending SMS to another member' do
      before(:each) do
        x = mem1; y = mem2
        login_with mem1
        visit '/paging/new'
        check("broadcast_member_recipients_#{mem2.id}")
        uncheck('phoneCheck')
        fill_in 'txtShort', with: Time.now
        click_button 'Send'
      end

      it 'generates the right number of outputs' do
        expect(Pgr::Broadcast.count).to eq(1)
        expect(Pgr::Dialog.count).to    eq(1)
        expect(Pgr::Post.count).to      eq(1)
        expect(Pgr::Outbound.count).to  eq(2)
      end
    end

    context 'when sending eMail and SMS to another member' do
      before(:each) do
        x = mem1; y = mem2
        login_with mem1
        visit '/paging/new'
        check("broadcast_member_recipients_#{mem2.id}")
        check('phoneCheck')
        check('emailCheck')
        fill_in 'txtShort', with: Time.now
        click_button 'Send'
      end

      it 'generates the right number of outputs' do
        expect(Pgr::Broadcast.count).to  eq(1)
        expect(Pgr::Dialog.count).to     eq(1)
        expect(Pgr::Post.count).to       eq(1)
        expect(Pgr::Outbound.count).to   eq(4)
      end
    end

    context 'viewing the page count' do
      it 'shows the right page count', :js do
        expect(mem1).to be_present
        expect(mem2).to be_present
        login_with mem1
        visit '/paging/new'
        expect(page).to have_content('selected 0 of 2 members')
        check("broadcast_member_recipients_#{mem2.id}")
        expect(page).to have_content('selected 1 of 2 members')
        expect(page).to have_content('send to 1 member')
      end
    end
  end
end
