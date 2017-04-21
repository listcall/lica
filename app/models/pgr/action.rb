class Pgr::Action < ActiveRecord::Base

  ENABLED_OPTIONS = %i(None OpRsvp OpLeftHome OpReturnHome)

  # ----- Attributes -----

  # ----- Associations -----
  belongs_to :broadcast, :class_name => 'Pgr::Broadcast', :foreign_key => :pgr_broadcast_id

  # ----- Callbacks -----

  # ----- Class Methods -----

  def self.enabled
    ENABLED_OPTIONS.map { |x| eval "Pgr::Action::Sti#{x}" }
  end

  def self.label      ; 'TBD' ; end
  def self.about      ; 'TBD' ; end
  def self.usage_ctxt ; 'TBD' ; end
  def self.has_period ; false ; end
  def self.class_name ; name  ; end

  def self.profile
    %i(label about class_name usage_ctxt has_period).reduce({}) do |hsh, ele|
      hsh[ele] = self.send(ele); hsh
    end
  end

  def self.option_list
    enabled.map {|klas| klas.profile}
  end
end

# == Schema Information
#
# Table name: pgr_actions
#
#  id               :integer          not null, primary key
#  pgr_broadcast_id :integer
#  type             :string
#  xfields          :hstore           default("")
#  created_at       :datetime
#  updated_at       :datetime
#
