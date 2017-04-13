class EventBot

  attr_reader :event, :team

  WEEK_RANGE = 1

  def initialize(event)
    @event = event
    @team  = @event.team
  end

  def potential_parent_events
    partners    = team.accepted_partners
    partners.map do |team|
      [{text: "#{team.acronym} - create new event (#{event.start.strftime("%b %-d")})", value: "#{team.id}_new"}] +
        team.events.order(:start).between(event.start - WEEK_RANGE.weeks, event.start + WEEK_RANGE.weeks).map do |lcl_event|
          if is_in_excluded_list(lcl_event)
            false
          else
            {
              text:  "#{team.acronym} - #{lcl_event.title} (#{lcl_event.start.strftime("%b %-d")})",
              value: "#{team.id}_#{lcl_event.id}"
            }
          end
        end
    end.flatten.select {|x| x}.to_json
  end

  def potential_child_events
    partners    = team.accepted_partners
    partners.map do |team|
      [{text: "#{team.acronym} - create new event (#{event.start.strftime("%b %-d")})", value: "#{team.id}_new"}] +
        team.events.order(:start).between(event.start - WEEK_RANGE.weeks, event.start + WEEK_RANGE.weeks).map do |lcl_event|
          if is_in_excluded_list(lcl_event) || has_parent(lcl_event)
            false
          else
            {
              text:  "#{team.acronym} - #{lcl_event.title} (#{lcl_event.start.strftime("%b %-d")})",
              value: "#{team.id}_#{lcl_event.id}"
            }
          end
        end
    end.flatten.select{|x| x}.to_json
  end

  private

  def is_in_excluded_list(lcl_event)
    is_ancestor(lcl_event) || is_descendant(lcl_event)
  end

  def has_parent(lcl_event)
    lcl_event.parent
  end

  def is_ancestor(lcl_event)
    event.ancestors.include?(lcl_event)
  end

  def is_descendant(lcl_event)
    event.descendants.include?(lcl_event)
  end

end