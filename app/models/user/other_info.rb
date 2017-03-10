class User::OtherInfo < ActiveRecord::Base

  # ----- Associations -----

  belongs_to   :user, touch: true
  acts_as_list :scope => :user_id


  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Local Methods-----
  def export
    atts = attributes
    %w(id membership_id).each {|a| atts.delete(a)}
    atts
  end

  def output
    "#{label} / #{value}"
  end

end

# == Schema Information
#
# Table name: user_other_infos
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  label      :string(255)
#  value      :string(255)
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#
