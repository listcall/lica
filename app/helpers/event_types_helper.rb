module EventTypesHelper

  # ----- delete button -----

  def type_count(type)
    @type_count ||= {}
    return 0 unless (type_obj = current_team.event_types[type])
    @type_count[type] ||= current_team.events.where('typ ilike ?', type_obj.id).count
  end

  def delete_event_type_button(type_id)
    if type_count(type_id) != 0
      cls = 'btn btn-xs btn-disabled'
      link_to raw('<del>Delete</del>'), '#', :disabled => 'disabled', :class => cls
    else
      url = "/admin/event_types/#{type_id}"
      msg = {confirm: 'Are you sure?'}
      cls = 'btn btn-xs btn-danger'
      link_to 'Delete', url, method: :delete, data: msg, class: cls
    end
  end

  # ----- transit switch -----

  def event_transit_helper(event_type)
    colors  = 'data-on="warning" data-off="primary"'
    icons   = 'data-on-label="<b>yes</b>" data-off-label="<b>no</b>"'
    checked = event_type.use_transit? ? "checked='checked'" : ''
    raw <<-HTML
      <div id='transit_#{event_type.id}' class="make-switch switch-mini transitToggle" #{colors} #{icons}>
          <input #{checked} type="checkbox">
      </div>
    HTML
  end

  # ----- signin switch -----

  def event_signin_helper(event_type)
    colors  = 'data-on="warning" data-off="primary"'
    icons   = 'data-on-label="<b>yes</b>" data-off-label="<b>no</b>"'
    checked = event_type.use_signin? ? "checked='checked'" : ''
    raw <<-HTML
      <div id='signin_#{event_type.id}' class="make-switch switch-mini signinToggle" #{colors} #{icons}>
          <input #{checked} type="checkbox">
      </div>
    HTML
  end

  # ----- max period switch -----

  def event_period_helper(event_type)
    colors  = 'data-on="warning" data-off="primary"'
    icons   = 'data-on-label="<b>one</b>" data-off-label="<b>many</b>"'
    checked = event_type.max_periods == 'one' ? "checked='checked'" : ''
    raw <<-HTML
      <div id='period_#{event_type.id}' class="make-switch switch-mini periodToggle" #{colors} #{icons}>
          <input #{checked} type="checkbox">
      </div>
    HTML
  end

end