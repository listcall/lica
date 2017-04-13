require 'rails_helper'

describe 'AppAuth::Model' do
  it 'queries using arrays' do
    expect(Membership.where(rights: %w(owner manager)).pluck(:id)).to be_empty
  end

  # it 'queries arrays' do
  #   qry = Membership.where.overlap(roles: %w(TM OL)).pluck(:id)
  #   expect(qry).to be_empty
  # end
end