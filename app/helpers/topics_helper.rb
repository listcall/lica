module TopicsHelper

  def topic_type(forum)
    forum.type.gsub('Fm', 'Tp')
  end

  def topic_status_helper(topic)
    open    = topic.status == 'Open'
    colors  = 'data-on="success" data-off="danger"'
    icons   = 'data-on-label="Open" data-off-label="Closed"'
    checked = open ? "checked='checked'" : ''
    raw <<-HTML
      <div id='status_#{topic.id}' class="make-switch switch-mini statusToggle" #{colors} #{icons}>
          <input #{checked} type="checkbox">
      </div>
    HTML
  end

  def topic_subscription_helper(topic)
    no_forum_sub = ForumSubscription.where(forum_id: topic.forum.id, membership_id: current_membership.id).to_a.empty?
    return raw "<i class='fa fa-eye green'></i>" unless no_forum_sub
    colors  = 'data-on="success" data-off="danger"'
    icons   = %q[data-on-label="<i class='fa fa-eye'></i>" data-off-label="<i class='fa fa-eye-slash'></i>"]
    no_subs = ForumTopicSubscription.where(forum_topic_id: topic.id, membership_id: current_membership.id).to_a.empty?
    checked = no_subs ? '' : "checked='checked'"
    raw <<-HTML
      <div id='watch_#{topic.id}' class="make-switch switch-mini watchToggle" #{colors} #{icons}>
          <input #{checked} type="checkbox">
      </div>
    HTML
  end

  def linker(text)
    raw "<a href='#'>#{text}</a>"
  end

  def topic_label(type)
    return '' if type.blank?
    case type.gsub(/Fm|Tp/,'')
      when 'Discussion' then 'Topic'
      when 'Issue'      then 'Issue'
      when 'Question'   then 'Question'
    end
  end

  def is_type(object, type)
    return if object.try(:type).empty?
    object.type.gsub(/Fm|Tp/,'') == type
  end

  def topic_table_for(forum)
    case forum.type.gsub(/Fm|Tp/,'')
      when 'Discussion' then 'topic_table_discussion'
      when 'Issue'      then 'topic_table_issue'
      when 'Question'   then 'topic_table_discussion'
    end
  end

  def status(topic)
    return 'Open' if topic.status.blank?
    topic.status
  end

  def assignee(topic)
    return 'none' if topic.assignee.blank?
    topic.assignee.user.user_name
  end

end
