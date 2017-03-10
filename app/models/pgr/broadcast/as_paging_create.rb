class Pgr::Broadcast::AsPagingCreate < ActiveType::Record[Pgr::Broadcast]

  accepts_nested_attributes_for :assignments, :action

  # ----- associations -----

  change_association :assignments, class_name: 'Pgr::Assignment::AsPagingCreate'
  change_association :dialogs    , class_name: 'Pgr::Dialog::AsPaging'

  # ----- validations -----

  # ----- callbacks -----

  # ----- instance methods -----

end

# == Schema Information
#
# Table name: pgr_broadcasts
#
#  id            :integer          not null, primary key
#  sender_id     :integer
#  short_body    :text
#  long_body     :text
#  deliver_at    :datetime
#  recipient_ids :integer          default("{}"), is an Array
#  xfields       :hstore           default("")
#  jfields       :jsonb            default("{}")
#  created_at    :datetime
#  updated_at    :datetime
#
