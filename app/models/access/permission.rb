class Access::Permission < ActiveRecord::Base

  self.table_name = "access_permissions"

  # ----- Attributes -----

  alias_attribute :label, :acronym

  # ----- Associations -----

  belongs_to :access_role
  # has_many   :assignments, :foreign_key => 'team_role_id', :class_name => 'Team::RoleAssignment'
  # has_one    :position   , :foreign_key => 'team_role_id', :class_name => 'Position', :dependent => :destroy

  # ----- Validations -----
  # VALID_RIGHTS = %w(owner manager active)
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
    self.rights ||= 'active'
    self.has ||= 'one'
    self.sort_key ||= 0
  end
end

# == Schema Information
#
# Table name: access_permissions
#
#  id             :integer          not null, primary key
#  access_role_id :integer
#  label          :string
#
