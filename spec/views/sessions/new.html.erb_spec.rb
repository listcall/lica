require 'spec_helper'

describe 'sessions/new.html.erb' do
  it 'renders the login form' do
    @user = User.new
    # noinspection RubyArgCount
    render
    expect(rendered).not_to be_nil
    expect(rendered).to have_selector('form')
    expect(rendered).to have_selector('#user_password')
    expect(rendered).to have_selector('#user_user_name')
  end
end
