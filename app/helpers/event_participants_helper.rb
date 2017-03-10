module EventParticipantsHelper

  #def delete_event_participant_button(period)
  #  if period.participants.count != 0 || num_siblings(period) < 2
  #    cls = 'btn btn-xs btn-disabled'
  #    link_to raw("<del>Delete</del>"), '#', :disabled => 'disabled', :class => cls
  #  else
  #    url = "/events/#{period.event.event_ref}/periods/#{period.position}"
  #    msg = {confirm: 'Are you sure?'}
  #    cls = 'btn btn-xs btn-danger'
  #    link_to 'Delete', url, method: :delete, data: msg, class: cls
  #  end
  #end


end
