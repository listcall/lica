require 'rails_helper'
require 'ext/time'

feature 'Avail/Days', :capy do
  let(:orgn) { FG.create(:org)                                            }
  let(:team) { FG.create(:team, org_id: orgn.id)                          }
  let(:usr1) { FG.create(:user_with_phone_and_email)                      }
  let(:usr2) { FG.create(:user_with_phone_and_email)                      }
  let(:mem1) { FG.create(:membership, team_id: team.id, user_id: usr1.id) }
  let(:mem2) { FG.create(:membership, team_id: team.id, user_id: usr2.id) }

  let(:indx_path) { '/avail/weeks'                      }
  let(:show_path) { "/avail/weeks/#{mem1.user_name}"    }

  before(:each) do
    set_host_url(team, orgn)
    login_with mem1
    visit show_path
  end

  describe 'basic rendering' do
    context 'with generated user' do
      it 'renders indx_path' do
        capy_create_member_and_login team
        visit indx_path
        expect(current_path).to eq(indx_path)
        expect(page.status_code).to be 200
        expect(page).not_to be_nil
      end
    end

    context 'with factory user' do
      it 'renders indx_path' do
        login_with mem1
        visit indx_path
        expect(page.status_code).to be 200
      end

      it 'renders show_path' do
        login_with mem1
        visit show_path
        expect(page.status_code).to be 200
      end
    end
  end

  describe 'status buttons' do
    context 'on first visit' do
      it 'has unmodified records' do
        expect(Avail::Week.count).to eq(13)
        expect(Avail::Week.undefined.count).to eq(13)
        expect(Avail::Week.avail.count).to eq(0)
        expect(Avail::Week.unavail.count).to eq(0)
      end
    end

    context 'when clicking first avail', :js do
      it 'modifies one record' do
        first('.avail').click
        wait_for_ajax
        expect(Avail::Week.avail.count).to eq(1)
      end
    end

    context 'when clicking first unavail', :js do
      it 'modifies one record' do
        first('.unava').click
        wait_for_ajax
        expect(Avail::Week.unavail.count).to eq(1)
      end
    end

    context 'when clicking all avail', :js do
      it 'modifies all records' do
        first('#allAvail').click
        wait_for_ajax
        expect(Avail::Week.avail.count).to eq(13)
      end
    end

    context 'when clicking all unavail', :js do
      it 'modifies all records' do
        first('#allUnava').click
        wait_for_ajax
        expect(Avail::Week.unavail.count).to eq(13)
      end
    end
  end

  describe 'updating a comment', :js do
    it 'modifies a record' do
      first('.inline.textEditable').click
      first('.textInput').set('asdf')
      first('.editable-submit').click
      wait_for_ajax
      visit show_path
      expect(Avail::Week.first.comment).to eq('asdf')
    end
  end

  describe 'quarter navigation', :js do
    it 'works for prev quarter' do
      expect(Avail::Week.count).to eq(13)
      expect(page).to_not have_css('.fa-home')
      first('.fa-chevron-left').click
      sleep 0.1
      expect(page).to have_css('.fa-home')
      expect(Avail::Week.count).to eq(26)
    end

    it 'works for next quarter' do
      expect(Avail::Week.count).to eq(13)
      expect(page).to_not have_css('.fa-home')
      first('.fa-chevron-right').click
      sleep 0.1
      expect(page).to have_css('.fa-home')
      expect(Avail::Week.count).to eq(26)
    end
  end
end