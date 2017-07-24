module PagingHelper

  def roles_helper(member)
    return '' if member.roles.blank?
    " (#{member.roles.join(', ')})"
  end

  #FIXME:XXX Appears broken in both listcall and devc
  def paging_new_reserve_checkbox(team)
    return '' if team.memberships.where(rights: 'reserve').count == 0
    raw <<-ERB
    <div style='width: 100%; text-align: right;'>
      <small>show #{reserve_member_labels(team)} members #{paging_new_reserve_checkbox_html}</small>
    </div>
    ERB
  end

  def pgr_mem_link(mem)
    if mem.team == current_team
      raw "#{link_to(mem.user_name, "/members/#{mem.user_name}", target:"_blank")} #{team_icon_path(mem)}"
    else
      raw "#{mem.user_name} #{team_icon_path(mem)} "
    end
  end

  def reserve_member_labels(team)
    team.ranks.reserve_rank_labels.join(', ')
  end

  def paging_new_reserve_checkbox_html
    check = cookies['paging_new_reserves'] == 'true' ? 'checked' : ''
    "<input style='vertical-align: -3px; cursor: pointer;' id='reserveCheckBox' type='checkbox' name='checkbox' value='value' #{check}>"
  end

end
