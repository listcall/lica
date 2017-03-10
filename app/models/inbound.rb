require 'app_ext/pkg'

=begin
TODO: design question...
Inbounds are attached to Teams.
In some situations it will make sense to attach inbounds to Dialogs.
Should inbounds always be attached to dialogs?  Probably so...
This causes problems in Inbound::StiPhone#origin_phone_allowed?
=end

class Inbound < ActiveRecord::Base

  # ----- Attributes -----
  alias_attribute :origin     , :fm
  alias_attribute :destination, :to

  # ----- Associations -----

  belongs_to :team  , touch: true
  belongs_to :dialog, class_name: 'Pgr::Dialog', foreign_key: 'pgr_dialog_id'

  # ----- Callbacks -----


  # ----- Validations -----


  # ----- Scopes -----


  # ----- Instance Methods -----

  def orig_email_registered?; true; end   # override in StiEmail
  def orig_phone_registered?; true; end   # override in StiPhone
  def orig_email_allowed?;    true; end   # override in StiEmail
  def orig_phone_allowed?;    true; end   # override in StiPhone
  def dest_email_valid?;      true; end   # override in StiEmail
end

# == Schema Information
#
# Table name: inbounds
#
#  id               :integer          not null, primary key
#  team_id          :integer
#  pgr_dialog_id    :integer
#  type             :string
#  proxy            :string
#  subject          :string
#  fm               :string
#  to               :string           default("{}"), is an Array
#  headers          :hstore           default("")
#  text             :text
#  destination_type :string
#  destination_id   :integer
#  xfields          :hstore           default("")
#  created_at       :datetime
#  updated_at       :datetime
#
