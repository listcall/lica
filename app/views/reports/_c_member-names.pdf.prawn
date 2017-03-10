def gen_array
  @members.in_groups_of(5).reduce([]) do |a,g|
    a << g.map {|m| m.try(:full_name)}
  end
end

def team_name
  current_team.acronym
end

prawn_document() do |pdf|

  pdf.text "<b>#{team_name} Roster</b>", :inline_format => true

  pdf.move_down 15
  pdf.text "#{team_name} is a resource of the San Mateo County Sheriff's Office of Emergency Services."

  pdf.move_down 15
  pdf.text "This roster is current as of #{Time.now.strftime("%D %H:%M")}."
  pdf.table(gen_array)

  pdf.move_down 15

  pdf.text "#{team_name} Confidential", :size=>8, :align => :center

end