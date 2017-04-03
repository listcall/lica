require 'rails_helper'

describe 'Page Rendering' do

  include_context 'Integration Environment'

  describe 'public user authentication' do
    it 'generates a redirect' do
      get "http://#{team1.fqdn}"
      expect(response.status).to eq(302)
      follow_redirect!
      expect(path).to eq('/login')
      expect(response.status).to eq(200)
    end
  end

  describe 'logging in' do
    context 'single session' do
      it 'works' do
        request_login(mem1)
        get '/'
        expect(response.status).to eq(200)
        expect(path).to eq('/')
      end
    end

    context 'multi-session' do
      it 'works' do
        session1 = request_login_session(mem1)
        session2 = request_login_session(mem2)
        session1.get '/'
        expect(session1.response.status).to eq(200)
        expect(session1.path).to eq('/')
        session2.get '/'
        expect(session2.response.status).to eq(200)
        expect(session2.path).to eq('/')
      end #
    end
  end
end
