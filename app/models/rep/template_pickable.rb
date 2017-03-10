class Rep::TemplatePickable < ActiveRecord::Base

  extend Forwardable

  # ----- attributes -----
  def_delegators :rep_template_db, :owner_team, :name

  # ----- associations -----
  belongs_to :rep_template_db , :class_name => 'Rep::TemplateDb', touch: true, :foreign_key => 'rep_template_db_id'
  belongs_to :picker_team     , :class_name => 'Team'

  alias :template :rep_template_db
  alias :team :picker_team

  # ----- scopes -----
  # returns a list of pickables that partners have shared with the team
  def self.partner_shared_with(team)
    team_id = team.to_i
    joins(:rep_template_db).where('rep_template_dbs.owner_team_id != ?', team_id).
      where(picker_team_id: team_id).order(:sort_key)
  end

  # returns a list of pickables that the team has shared internally
  def self.self_shared_with(team)
    team_id = team.to_i
    joins(:rep_template_db).where('rep_template_dbs.owner_team_id = ?', team_id).
      where(picker_team_id: team_id).order(:sort_key)
  end

  # returns a  list of pickables that the team has shared with other partners
  def self.shared_for_partners_by(team)
    team_id = team.to_i
    joins(:rep_template_db).where('rep_template_dbs.owner_team_id = ?', team_id).
      where('picker_team_id != ?', team_id).order(:sort_key)
  end

  # ----- klass methods -----
  def self.make_for(team, template)
    opts = {
      picker_team_id:  team.to_i,
      rep_template_db_id: template.to_i
    }
    where(opts).first_or_create
  end

  # ----- local methods -----
  def team_acronym
    team.try(:acronym)
  end

  def team_id
    team.try(:id)
  end

  def dependent_reps
    rep_template_db.dependent_reps
  end
end

# == Schema Information
#
# Table name: rep_template_pickables
#
#  id                 :integer          not null, primary key
#  picker_team_id     :integer
#  rep_template_db_id :integer
#  sort_key           :integer
#  xfields            :hstore           default("")
#  jfields            :jsonb            default("{}")
#  created_at         :datetime
#  updated_at         :datetime
#
