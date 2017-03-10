# integration_test: features/admin/svc_reps

require 'ext/hash'

class Rep < ActiveRecord::Base
  acts_as_list :scope => :team_id, :column => :sort_key

  # ===== associations =====
  belongs_to :team, touch: true

  # ===== scopes =====
  scope :sorted   , -> { order(:sort_key)                           }
  scope :service  , -> { where(type: 'Rep::StiService')             }

  def self.with_template(template)
    t_id = template.is_a?(String) ? template : template.id.to_s
    where('base_template_id = ? OR fork_template_id = ?', t_id, t_id )
  end

  # ===== validations =====
  validates :base_template_id, presence: true

  # ===== callbacks =====
  before_validation :set_base_template_id
  before_destroy    :cleanup_templates

  # ===== public instance methods =====
  # ----- util -----
  def with_opts(*opts)
    opts.each {|hsh| template.opt_merge hsh}
    template.opt_merge report_opts
    self
  end

  def ctx_json
    template.ctx_json
  end

  # ----- template manipulation -----
  def fork
    forked?
  end

  def fork=(boolean_string)
    raise "Can't fork without team_id" if team_id.nil?
    boolean_string.to_s.is_true? ? create_fork : delete_fork
  end

  # ----- get/set template -----
  def template
    get_template(fork_template_id || base_template_id)
  end

  def template=(value)
    delete_fork
    self.base_template_id = value
  end

  # ----- template text -----
  def template_text
    template.text
  end

  def template_text=(text)
    fork_template.try(:update_attribute, :text, text)
  end

  # ----- template content -----
  def template_content
    template.content
  end

  # ----- get/set fork template name -----
  def fork_tmpl_name
    fork_template.name
  end

  def fork_tmpl_name=(new_name)
    tmpl = fork_template
    return if tmpl.blank?
    tmpl.update_attribute(:name, new_name)
  end

  # ----- share within current team -----
  def pick_self
    return false unless forked?
    fork_template.get_self_picks_for(team_id).present?
  end
  alias_method :share_internal?, :pick_self

  def pick_self=(boolean_string)
    raise 'no fork' unless forked?
    fork_template.set_self_picks_for(team_id, boolean_string)
  end

  # ----- share with partners -----
  def pick_partner_ids
    fork_template.pick_partner_ids
  end

  def pick_partner_ids=(list)
    fork_template.pick_partner_ids=(list)
  end

  # ----- utility methods -----
  def forked?
    fork_template.present?
  end
  alias_method :fork, :forked?

  # ----- template selection -----
  class << self
    def base_templates
      %i(_base)    # override in sub-class !!
    end

    def default_base_template
      base_templates.first
    end
  end

  def template_opts
    alt = base_template_opts + self_shared_template_opts + partner_shared_template_opts
    alt.to_json
  end

  private

  def base_template_opts
    self.class.base_templates.map do |str|
      {value: str, text: str.gsub('_', ' ').titleize}
    end
  end

  def self_shared_template_opts
    Rep::TemplatePickable.self_shared_with(team).map do |pickable|
      next if self.fork_template_id.try(:to_i) == pickable.rep_template_db_id
      {value: pickable.template.id, text: "t: #{pickable.template.name}"}
    end.compact
  end

  def partner_shared_template_opts
    Rep::TemplatePickable.partner_shared_with(team).map do |pickable|
      {value: pickable.template.id, text: "p: #{pickable.template.name}"}
    end
  end

  # ----- callbacks -----
  def set_base_template_id
    return unless base_template_id.blank?
    self.base_template_id = self.class.default_base_template
  end

  # ----- fork manipulation -----
  def create_fork
    return if forked?
    opts = {
      name:          "tmpl#{rand(6 ** 6).to_s.rjust(6,'0')}",
      text:          base_template.content_w_opts,
      cfgs:          base_template.cfgs,
      owner_team_id: team_id
    }
    tmpl = Rep::TemplateDb.create opts
    update_attribute(:fork_template_id, tmpl.id.to_s)
  end

  def delete_fork
    return unless forked?
    fork_template.destroy
    update_attribute(:fork_template_id, nil)
  end

  def cleanup_templates
    base_template.try(:destroy)
    fork_template.try(:destroy)
  end

  # ----- template accessors -----
  def get_template(template_id)
    @tmpl ||= Hash.new do |h,key|
      h[key] = fetch(template_id)
    end
    @tmpl[template_id]
  end

  def fetch(id)
    Rep::TemplateDb.fetch(id) || Rep::TemplateFs.fetch(id)
  end

  def base_template
    fetch(base_template_id)
  end

  def fork_template
    return nil unless fork_template_id.present?
    fetch(fork_template_id)
  end

  def report_opts
    {report: self}
  end
end

# == Schema Information
#
# Table name: reps
#
#  id               :integer          not null, primary key
#  type             :string
#  team_id          :integer
#  name             :string
#  base_template_id :text
#  fork_template_id :text
#  visibility       :string
#  sort_key         :integer
#  values           :hstore           default("")
#  xfields          :hstore           default("")
#  jfields          :jsonb            default("{}")
#  created_at       :datetime
#  updated_at       :datetime
#
