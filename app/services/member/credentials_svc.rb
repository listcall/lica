require 'task_sort'

class Member::CredentialsSvc

  attr_reader :membership

  def initialize(membership)
    @membership = membership
  end

  # trigger: after_create membership callback
  def setup
    membership.rank_will_change!
    membership.roles_will_change!
    update   # runs end-to-end because membership.id != nil
  end

  # trigger: before_save membership callback
  def update
    validate_rank
    validate_role
    return if membership.id.blank?
    set_rank_assig
    set_role_assig
    set_rank_score
    set_role_score
    set_member_rights
  end

  # trigger: admin sorts rank
  def update_rank
    set_rank_assig
    set_rank_score
    set_member_rights
  end

  # trigger: admin sorts role or changes role rights
  def update_role
    set_role_assig
    set_role_score
    set_member_rights
  end

  private

  # ----- rank/role validation -----

  def validate_rank
    raise("Invalid Rank (#{membership.rank})") unless valid_rank?
  end

  def validate_role
    raise('Invalid Role') unless valid_roles?
  end

  def valid_rank?
    return false unless membership.team().present?
    xranks = membership.team.ranks
    xranks.pluck(:acronym).include? membership.rank
  end

  def valid_roles?
    return false unless membership.team().present?
    team_roles = membership.team.roles.pluck(:acronym)
    if (invalid_roles = (membership.roles - team_roles)).present?
      membership.update_column :roles, membership.roles - invalid_roles
      membership.reload
    end
    (membership.roles - team_roles) == []
  end

  # ----- ranks/role assignments -----

  def set_rank_assig
    until (assig = latest_rank_assig).nil? || assig.elapsed_time > 10.minutes do
      assig.destroy # wipe out old assignments if they lasted less than 10 mins
    end
    case assig.try(:rank).try(:acronym)
    when nil
      Team::RankAssignment.create_for(membership)
    when membership.rank
      assig.update_column(:finished_at, nil)
    else
      assig.update_attribute(:finished_at, Time.now) unless assig.nil?
      Team::RankAssignment.create_for(membership)
    end
  end

  def set_role_assig
    adds = membership.roles - membership.roles_was
    dels = membership.roles_was - membership.roles
    adds.each do |role|
      Team::RoleAssignment.create_for(membership, role)
    end
    dels.each do |role|
      Team::RoleAssignment.retire_for(membership, role)
    end
  end

  # ----- rank/role scores -----

  def set_rank_score
    membership.rank_score = calc_rank_score
  end

  def set_role_score
    membership.role_score = calc_role_score
  end

  # ----- rank/role support methods -----

  def latest_rank_assig
    membership.rank_assignments.latest.first
  end

  def rank_changed?
    @rank_changed ||= membership.rank_changed?
  end

  def roles_changed?
    @roles_changed ||= membership.roles_changed?
  end

  def calc_rank_score
    team = membership.team
    return 0 unless team.present?
    team.ranks.find_by(acronym: membership.rank).try(:sort_key) || 0
  end

  # use a binary index for calculating role score,
  # so that highest roles always appear first in sorted list
  # max number of roles is 32 (4 bytes - size of postgres integer)
  # note: this could be increased to 64 by using a postgres bigint field...
  def calc_role_score
    team       = membership.team
    team_roles = team.roles.pluck(:acronym).reverse
    return 0 if team_roles.blank?
    mem_roles = membership.roles
    mem_roles.reduce('0'*32) do |acc, role|
      acc[team_roles.index(role)] = '1'
      acc
    end.reverse.to_i(2)  # use a binary (base-2) string-to-int conversion...
  end

  # ----- member rights -----

  def set_member_rights
    mem  = membership
    team = mem.team
    return if team.nil?
    if mem.owner_plus == 'true'
      mem.rights = 'owner'
    else
      rank_rights = team.ranks.where(acronym: mem.rank).pluck(:rights)
      role_rights = team.roles.where(acronym: mem.roles).pluck(:rights)
      all_rights  = (rank_rights + role_rights).compact.uniq
      mem.rights  = all_rights.map {|x| Right(x)}.max.value
    end
    mem.rights_score = Right(mem.rights).score
  end
end