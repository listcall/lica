# integration_test: features/admin/svc_reps

class Rep::StiService < Rep

  # ===== attributes =====
  jfield_accessor :date_query  , default: ''
  jfield_accessor :service_ids , default: []
  jfield_accessor :service_tags, default: []

  # ===== class methods ======
  class << self
    def base_templates
      %w(_base _base1 _base2 _hello_world pie_chart schedule)
    end
  end

  # ===== instance methods =====
  def service_src
    data = team.svcs.map { |svc| %Q[{value: #{svc.id}, text:"#{svc.name}"}] }
    "[#{data.join(',')}]"
  end

  def id_plus_query
    qstring = self.date_query.blank? ? "" : "?#{self.date_query}"
    "#{id}#{qstring}"
  end

  # ===== lookup methods =====

  def participants
    Svc::Participant
      .joins(:svc_period)
      .joins(Svc::Period.joins(:svc).join_sources)
      .where('svcs.id' => service_ids)
  end

  def participants_between(start, finish)
    start_date  = start.is_a?(Time)  ? start : Time.parse(start)
    finish_date = finish.is_a?(Time) ? finish : Time.parse(finish)
    participants
      .where(Svc::Period.arel_table[:start].gt(start_date))
      .where(Svc::Period.arel_table[:finish].lt(finish_date))
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
#  values           :hstore           default({})
#  xfields          :hstore           default({})
#  jfields          :jsonb
#  created_at       :datetime
#  updated_at       :datetime
#
