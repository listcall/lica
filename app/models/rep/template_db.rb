# integration_test: features/admin/svc_reps

require 'preamble'
require_relative 'template_common'

class Rep::TemplateDb < ActiveRecord::Base

  include Rep::TemplateCommon

  # ===== attributes =====
  jfield_accessor :cfgs, default: {}

  # ===== associations =====

  belongs_to :owner_team             , :class_name => 'Team'
  has_many   :rep_template_pickables , :class_name => 'Rep::TemplatePickable', :dependent => :destroy, :foreign_key => 'rep_template_db_id'
  has_many   :picker_teams           , :through    => :rep_template_pickables

  alias :pickables :rep_template_pickables
  alias :team      :owner_team

  # def reports
  #   Rep.with_template(self)
  # end

  # ===== klass methods =====
  class << self
    def fetch(id)
      return nil if id.blank?
      return nil if id.match(/[^\d]/) unless id.is_a?(Integer)
      find Integer(id)
    end
  end

  # ===== local methods =====

  # ----- misc -----
  def opt_merge(new_opts)
    @new_opts = (@new_opts || {}).merge(new_opts)
  end

  def opts
    (template_opts || base_opts).merge(@new_opts || {})
  end

  # ----- share within current team -----
  def get_self_picks_for(team)
    raise 'no team' if team.blank?
    pickables.self_shared_with(team)
  end

  def set_self_picks_for(team, boolean_string = 'false')
    raise 'no team' if team.blank?
    if boolean_string.to_s.is_true?
      Rep::TemplatePickable.make_for(team, self)
    else
      get_self_picks_for(team).to_a.each {|pick| pick.destroy}
    end
  end

  # ----- share with partners -----
  def pick_partner_ids
    @ppids ||= pickables.map {|p| p.picker_team_id}
  end

  def pick_partner_ids=(list)
    list = list.nil? ? [] : list.map(&:to_i)
    pids = pick_partner_ids
    delete_list = pids - list
    create_list = list - pids
    create_list.each do |team_id|
      rep_template_pickables.find_or_create_by(picker_team_id: team_id)
    end
    delete_list.each do |team_id|
      rep_template_pickables.each do |pick|
        next if pick.picker_team_id == owner_team_id    # share with self...
        pick.destroy if pick.picker_team_id == team_id
      end
    end
  end

  # ----- misc methods -----
  def content_w_opts
    text
  end

  def destroy
    return if reports.count > 1
    super
  end

  private

  def preamble
    @pre ||= Preamble.import(text)
  end
end

# == Schema Information
#
# Table name: rep_template_dbs
#
#  id            :integer          not null, primary key
#  owner_team_id :integer
#  name          :text
#  text          :text
#  xfields       :hstore           default("")
#  jfields       :jsonb            default("{}")
#  created_at    :datetime
#  updated_at    :datetime
#
