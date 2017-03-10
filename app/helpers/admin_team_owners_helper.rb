module AdminTeamOwnersHelper

  def owner_plus_cell(mem)
    hl = mem.owner_plus == 'true' ? 'hlg' : ''
    raw "<td class='ocell #{hl}' id='od_#{mem.id}'>#{mem.full_name}</td>"
  end

end