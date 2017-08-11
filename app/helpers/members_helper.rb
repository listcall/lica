module MembersHelper

  def rank_name(member)
    member.team.ranks.find_by(acronym: member.rank).name
  end

  def role_names(member)
    role_name = ->(role) { member.team.roles.find_by(acronym: role).try(:name) }
    member.ordered_roles.map {|role| role_name.call(role)}.join(', ')
  end

  def pagable_phone_helper(phone)
    icon_class = phone.pagable? ? 'fa fa-bullhorn green_phone' : 'fa fa-ban red_phone'
    icon_htm   = "<i id='phone_#{phone.id}' class='#{icon_class}'>"
    if @editable
      if phone.typ.in?(%w(Mobile Pager))
        raw "<a href='#' class='editable-click pagable'>#{icon_htm}</i></a>"
      else
        raw "<span class='pagable-restricted'>#{icon_htm}</span>"
      end
    else
      raw "<span class='pagable-view'>#{icon_htm}</span>"
    end
  end

  def pagable_email_helper(email)
    icon_class = email.pagable? ? 'fa fa-bullhorn green_email' : 'fa fa-ban red_email'
    icon_htm   = "<i id='email_#{email.id}' class='#{icon_class}'></i>"
    if @editable
      raw "<a href='#' class='editable-click pagable'>#{icon_htm}</a>"
    else
      raw "<span class='pagable-view'>#{icon_htm}</span>"
    end
  end

  def contact_json_helper(con)
    %Q[{"name":"#{con.name}", "kinship":"#{con.kinship}"}]
  end

  def address_json_helper(adr)
    %Q[{"address1":"#{adr.address1}", "address2":"#{adr.address2}", "city":"#{adr.city}", "state":"#{adr.state}", "zip":"#{adr.zip}"}]
  end

  def name_json_helper(user)
    %Q[{"title":"#{user.title}", "first_name":"#{user.first_name}", "middle_name":"#{user.middle_name}", "last_name":"#{user.last_name}"}]
  end

  def visible_phone_helper(phone)
    icon_class = phone.visible? ? 'fa fa-eye visible_phone' : 'fa fa-eye-slash obscure_phone'
    icon_htm   = "<i id='phone_visible_#{phone.id}' class='#{icon_class}'>"
    return raw(icon_htm) unless @editable
    raw "<a href='#' class='editable-click visible'>#{icon_htm}</i></a>"
  end

  def visible_contact_helper(contact)
    icon_class = contact.visible? ? 'fa fa-eye visible_conta' : 'fa fa-eye-slash obscure_conta'
    icon_htm   = "<i id='contact_visible_#{contact.id}' class='#{icon_class}'>"
    return raw(icon_htm) unless @editable
    raw "<a href='#' class='editable-click visible'>#{icon_htm}</i></a>"
  end

  def visible_email_helper(email)
    icon_class = email.visible? ? 'fa fa-eye visible_email' : 'fa fa-eye-slash obscure_email'
    icon_htm   = "<i id='email_visible_#{email.id}' class='#{icon_class}'>"
    return raw(icon_htm) unless @editable
    raw "<a href='#' class='editable-click visible'>#{icon_htm}</i></a>"
  end

  def visible_address_helper(address)
    icon_class = address.visible? ? 'fa fa-eye visible_addrs' : 'fa fa-eye-slash obscure_addrs'
    icon_htm   = "<i id='address_visible_#{address.id}' class='#{icon_class}'>"
    return raw(icon_htm) unless @editable
    raw "<a href='#' class='editable-click visible'>#{icon_htm}</i></a>"
  end

  def can_see(current_member, tgt_member)
    return true if current_member == tgt_member
    return true if %w(inactive alum guest).include? tgt_member.rights
    return true if manager_rights?
    false
  end

  def can_delete(current_member, tgt_member)
    return false if current_member == tgt_member
    return false unless manager_rights?
    return false if tgt_member.participations.count > 0
    return false if Integer(tgt_member.sign_in_count) > 0
    true
  end

  def delete_button_for(tgt_mem)
    msg = raw "Delete Membership for <b>#{tgt_mem.full_name}</b>"
    path = "/members/#{tgt_mem.id}"
    conf = "Are you sure you want to delete the Membership for #{tgt_mem.full_name}?"
    hash = {
      :method => :delete,
      :data   => { :confirm => conf},
      :class  => 'btn btn-xs btn-danger',
      :style  => 'width: 100%; margin-bottom: 6px;'
    }
    link_to msg, path, hash
  end

  def events_for(member, type)
    incl = {:period => :event}
    member.participations.includes(incl).by_event_type(type).ordered
  end

end
