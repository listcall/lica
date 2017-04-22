require 'rails_helper'
require 'ext/time'

feature 'events#new', :capy do

  include_context 'Integration Environment'

  before(:each) { set_feature_host(team1) }

  describe 'basic rendering' do
    context 'with generated user' do
      it 'renders /events/new' do
        capy_create_member_and_login team1
        visit '/events/new'
        expect(current_path).to eq('/events/new')
        expect(page.status_code).to be 200
        expect(page).not_to be_nil
      end
    end

    context 'with factory user' do   #
      it 'renders /events/new' do
        login_with mem1
        visit '/events/new'
        expect(page.status_code).to be 200
      end
    end

    describe 'event generation' do #.......
      let(:title) { 'ASDF' }
      let(:lname) { 'QWER' }

      it 'generates an event' do
        login_with mem1
        visit '/events/new'
        expect(Event.count).to eq(0)
        fill_in 'Title'      , with: title
        fill_in 'frmNam'     , with: lname
        fill_in 'startDate'  , with: Time.now.date_part
        fill_in 'finishDate' , with: Time.now.date_part
        click_button 'Create Event'
        expect(Event.count).to eq(1)
      end

      # THERE IS A PROBLEM WITH THE ALL_DAY CHECKBOX
      # CAN'T TURN IT ON.  2014-Jan-04
      it 'generates the correct event attributes' do
        login_with mem1
        visit '/events/new'
        fill_in 'Title'      , with: title
        fill_in 'frmNam'     , with: lname
        fill_in 'startDate'  , with: Time.now.date_part
        fill_in 'finishDate' , with: Time.now.date_part
        check   'dayChx'
        click_button 'Create Event'
        ev = Event.first
        expect(ev).to be_valid
        expect(ev.title).to eq(title)
        expect(ev.location_name).to eq(lname)
        expect(ev.start.date_part).to eq(Time.now.date_part)
      end
    end
  end
end