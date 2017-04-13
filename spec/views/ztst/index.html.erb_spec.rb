require 'rails_helper'

describe 'ztst/index.html.erb' do
  it 'renders properly' do
    # noinspection RubyArgCount
    render
    expect(rendered).not_to be_nil
  end
end