module Ajax::ActionOpRsvpHelper
  def alt_response_list(action, current, asid)
    current_ans = current.split(':')[0].downcase
    action.prompts.except(current_ans).map do |key, prompt|
      path = "/ajax/action_op_rsvp/#{@dialog.id}?new_resp=#{key}&asid=#{asid}"
      link_to raw("<b>#{key.capitalize}:</b> #{prompt}"), path, :method => :put
    end.join('</br>')
  end
end