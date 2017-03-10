module EventPeriodsHelper

  # ----- show -----

  def aar_link_for(period)
    show = "<a href='/event_reports/#{period.period_ref}' target='_blank'>show</a>"
    edit = "<a target='_blank' href='/event_reports/#{period.period_ref}/edit'>edit</a>"
    return "SMSO AAR: #{show} | #{edit}"
  end

  def mem_link(member)
    return if member.blank?
    img_link = "<img class='smAvatar' src='#{member.avatar(:icon)}' />"
    mem_link = <<-ERB
      <a class='memlink' href='/members/#{member.user_name}' target='_blank'>
        <strong>#{member.full_name}</strong>
      </a>
    ERB
    raw "#{img_link}#{mem_link}"
  end

  def child_mem_link(member)
    return if member.blank?
    raw <<-ERB
      <img class='smAvatar' src='#{member.avatar(:icon)}' />
      <strong>#{member.full_name}</strong>
    ERB
  end

  def signin_field(participant)
    input_box_signin("signed_in-#{participant.id}", participant.signed_in_at)
  end

  def signout_field(participant)
    return '' if participant.signed_in_at.blank?
    input_box_signin("signed_out-#{participant.id}", participant.signed_out_at)
  end

  def if_partner(participant, time, output_field)
    if current_team.partnered_with?(participant.event.team)
      output_field
    else
      time.try(:strftime, '%Y-%m-%d %H:%M')
    end
  end

  def depart_field(participant)
    input_box_transit("departed-#{participant.id}", participant.departed_at)
  end

  def return_field(participant)
    return '' if participant.departed_at.blank?
    input_box_transit("returned-#{participant.id}", participant.returned_at)
  end

  def input_box_signin(id, input)
    input_box(id, input, 'signin', 'ellipsis-v')
  end

  def input_box_transit(id, input)
    input_box(id, input, 'transit', 'gavel')
  end

  def input_box(id, input, type, icon)
    date = input.try(:strftime, '%Y-%m-%d %H:%M')
    cat  = id.split('-')[0]
    style = "style='border-top-right-radius: 4px; border-bottom-right-radius: 4px;'"
    raw <<-ERB
      <div class="input-group input-group-sm #{cat}" style='width: 175px;' >
        <span id="action.#{id}" class='input-group-addon #{type}Action' data-toggle='tooltip'><i class='fa fa-#{icon}'></i></span>
        <input id="#{id}" type="text" data-current='#{date}' class="form-control parDateInput" value='#{date}' #{style}/>
        #{clear_button(id, date)}
      </div>
    ERB
  end

  def clear_button(id, date)
    return '' if date.blank?
    "<span id='clear.#{id}' class='parDateClear'></span>"
  end

end