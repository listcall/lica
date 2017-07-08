require 'rails_helper'

# TODO: fix the slow specs that are timing-out

feature 'members#show'  do

  include_context 'Integration Environment'

  feature 'page rendering' do
    before(:each) { set_feature_host(team1) }

    context 'when logged as member' do
      let(:user1)  { capy_create_member_and_login(team1)     }
      let(:user2)  { capy_member_login(mem2)                 }
      let(:path1)  { "/members/#{user1.user_name}"           }
      let(:path2)  { "/members/#{user2.user_name}"           }

      it 'renders the member page' do
        visit path1
        expect(current_path).to eq(path1)
        expect(page.status_code).to be 200
        expect(page).not_to be_nil
        expect(page).to have_content('John')
      end

      it 'renders in edit mode' do
        visit path1
        expect(page).to have_link('Create')
      end

      context 'when editing the member name', :js do
        # it 'brings up the edit dialog' do
        #   visit path1
        #   page.find('#fullEdit').click
        #   expect(page).to have_content('Required')
        # end

        # it 'updates and saves the name' do
        #   visit path1
        #   expect(page).to_not have_content('Joe')
        #   page.find('#fullEdit').click
        #   fill_in 'First:', with: 'Joe'
        #   page.find('.glyphicon-ok').click
        #   expect(page).to have_content('Joe')
        # end
      end

      # FIXME ALT
      # context 'when creating a phone', :js do
      #   it 'brings up the create dialog' do
      #     pending "Fails on VM - possible timing issue"
      #     fail
      #     visit path1
      #     page.find('#phoneCreate').click
      #     expect(page).to have_content('Create New Phone for John')
      #   end
      #
      #   # it "allows creation of the phone"
      #   # it "displays validation errors"
      # end

      context 'when displaying a phone', :js do
        # it 'displays the phone number' do
        #   visit path2
        #   expect(page).to have_link('Delete')
        # end

        # FIXME ALT
        # context 'when the phone is mobile' do
        #   it "displays the pagable indicator"
        # end
        # context 'when the phone is not mobile' do
        #   it "does not display the pagable indicator"
        # end
      end

      # FIXME ALT
      # context "when editing a phone", :js do
        # it "displays the phone number"
        # it "edits the phone number"
        # it "edits the phone type"
        # it "edits the phone pagability"
        # it "edits the phone visibility"
      # end
      context 'when deleting a phone'
      context 'when sorting phones'
      context 'when creating an email'
      context 'when editing an email'
      context 'when deleting an email'
      context 'when sorting emails'
      context 'when creating an address'
      context 'when editing an address'
      context 'when deleting an address'
      context 'when sorting addresss'
      context 'when creating a contact'
      context 'when editing a contact'
      context 'when deleting a contact'
      context 'when sorting contacts'
    end
  end
end