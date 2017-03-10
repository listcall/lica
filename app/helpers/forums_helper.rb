module ForumsHelper

  def forum_types
    [
        %w(Discussion FmDiscussion),
        %w(Issue      FmIssue),
    ]
  end

  def forum_subscription_helper(forum)
    colors  = 'data-on="success" data-off="danger"'
    icons   = %q[data-on-label="<i class='fa fa-eye'></i>" data-off-label="<i class='fa fa-eye-slash'></i>"]
    no_subs = ForumSubscription.where(forum_id: forum.id, membership_id: current_membership.id).to_a.empty?
    checked = no_subs ? '' : "checked='checked'"
    raw <<-HTML
      <div id='watch_#{forum.id}' class="make-switch switch-mini watchToggle" #{colors} #{icons}>
          <input #{checked} type="checkbox">
      </div>
    HTML
  end

end