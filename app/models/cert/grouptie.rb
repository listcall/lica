class Cert::Grouptie < ActiveRecord::Base

  self.table_name = "cert_grouptie"

  acts_as_list :scope => :cert_group_id, :column => :position

  # ----- Attributes -----

  alias_attribute :label, :acronym

  # ----- Associations -----

  belongs_to :cert_def    , class_name: 'Cert::Def'
  belongs_to :cert_group          , class_name: 'Cert::Group'

  # ----- Validations -----
  # VALID_RIGHTS = %w(owner manager active) #
  # validates_presence_of  :rights
  # validates_inclusion_of :rights, in: VALID_RIGHTS
  # validates :name   , :presence => true, :uniqueness => {:scope => :team_id}
  # validates :acronym, :presence => true, :uniqueness => {:scope => :team_id},
  #                     :format   => {with: /\A[a-zA-Z\d]*\z/, message: 'only letters or numbers'}
  # validate  :max_role_count

  # def max_role_count
  #   return unless self.team.present?
  #   if self.class.where(team_id: team_id).count > 31
  #     errors.add(:role_id, 'Error - Max number of roles reached')
  #   end
  # end

  # ----- Callbacks -----
  # before_validation  :upcase_acronym
  # after_initialize   :set_defaults

  # ----- Scopes -----

  # ----- Class Methods -----
  # class << self
  #   def set_defaults_for(team)
  #     ids = [
  #       {acronym: 'WEB', name: 'Web Master' , rights: 'owner'    },
  #       {acronym: 'SEC', name: 'Secretary'  , rights: 'manager'  },
  #       {acronym: 'TL' , name: 'Team Leader', rights: 'owner'    },
  #     ].map { |mdl| find_or_create_by(mdl.merge(team_id: team.id)).id }
  #     where(id: ids)  # return relation instead of array...
  #   end
  # end

  # ----- Instance Methods -----

  private

  def upcase_acronym
    self.acronym = self.acronym.try(:upcase)
  end

  def set_defaults
    return unless self.new_record?
    self.description ||= 'TBD'
    self.rights      ||= 'active'
    self.has         ||= 'one'
    self.sort_key    ||= 0
  end
end

# == Schema Information
#
# Table name: cert_grouptie
#
#  id            :integer          not null, primary key
#  cert_def_id   :integer
#  cert_group_id :integer
#  position      :integer
#
