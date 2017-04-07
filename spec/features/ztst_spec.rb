require 'rails_helper'

describe 'Ztst', :js do
  let(:orgn) { FG.create(:org)                    }
  let(:team) { FG.create(:team, org: orgn)        }

  before(:each) do
    set_host_url(team, orgn)
    capy_create_member_and_login team
  end

  context 'as a registered user' do
    # (ZTST_PAGES).each do |page_name|
    dong = %w(index pack2)
    dong.each do |page_name|
      puts page_name
      it "renders #{page_name}" do
        tst_path = "/ztst/#{page_name}"
        visit tst_path
        expect(current_path).to eq(tst_path)
        expect(page).not_to be_nil
      end
    end

    # it 'renders a react component' do
    #   tst_path = '/ztst/react4'
    #   visit tst_path
    # end
    #
    # it 'interacts with a react component' do
    #   tst_path = '/ztst/react4'
    #   visit tst_path
    #   expect(page.body).to include 'Numclicks: 0'
    #   first('.btn-success').click
    #   expect(page.body).to include 'Numclicks: 1'
    # end
  end
end