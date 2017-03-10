# TODO:
# - add page numbers
# - add headers/footers
# - add county numbers
# - indicate if the email addresses are pagable

def phone_for(member, type)
  eval "member.phones.#{type}.visible_for(current_membership).first.try(:number)"
end

def email_for(member, type)
  eval "member.emails.#{type}.visible_for(current_membership).first.try(:address)"
end

def team_name
  current_team.acronym
end

def gen_array

  hdr_fields = %w(# Last First Rank Mobile Home Work Personal\ eMail Work\ eMail)
  idx = 0
  data = @members.map do |m|
    [ idx += 1,
      m.last_name,
      m.first_name,
      m.rank,
      phone_for(m, "mobile"),
      phone_for(m, "home"),
      phone_for(m, "work"),
      email_for(m, "personal"),
      email_for(m, "work"),
    ]
  end

  [hdr_fields] + data

end


prawn_document(:border_width => 0, :page_layout => :portrait, :top_margin => 30, :bottom_margin => 30) do |pdf|

  pdf.text "#{team_name} Field Roster / Active Members / Generated #{Time.now.strftime("%Y-%m-%d %H:%M")} by @#{current_membership.user_name} / #{team_name} Confidential", :size=>9

  data = gen_array

  table_opts = {
    :header     => true,
    :row_colors => ["ffffff", "eeeeee"]
  }

  pdf.move_down 2

  pdf.font_size 7

  pdf.table data, table_opts do
    cells.padding_top    = 1
    cells.padding_bottom = 1
    cells.padding_left   = 5
    cells.padding_right  = 5
    cells.borders = [:left, :right]
    row(0).style(:borders => [:top, :left, :right], :font_style => :bold, :background_color => 'cccccc', )
    row(-1).style(:borders => [:bottom, :left, :right])
  end

end
