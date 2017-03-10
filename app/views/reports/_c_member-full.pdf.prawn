# TODO: add page header/footer, with page numbers ("page <number> of <total>")
# TODO: format phones, addresses, emails, emergency contacts

def gen_phone_numbers(member)
  member.phones.visible_for(current_membership).map do |phone|
    pagable = phone.pagable? ? '[pagable]' : ""
    "#{phone.typ} #{phone.number} #{pagable}"
  end.join("\n")
end

def gen_addresses(member)
  member.addresses.visible_for(current_membership).map do |address|
    adr = address.full_address
    "#{address.typ}\n#{adr}"
  end.join("\n\n")
end

def gen_contacts(member)
  member.emergency_contacts.visible_for(current_membership).map do |contact|
    "#{contact.name} / #{contact.kinship} - #{contact.phone_number} (#{contact.phone_type})"
  end.join("\n")
end

def gen_emails(member)
  member.emails.visible_for(current_membership).map do |email|
    "#{email.typ} #{email.address}"
  end.join("\n")
end

def team_name
  current_team.acronym
end

def gen_array

  headers = %w(Name\ /\ Role Addresses Phone\ Numbers eMail\ Addresses Emergency\ Contacts)

  data = @members.map do |m|
    ["#{m.full_name}\n#{m.rank}",
      gen_addresses(m),
      gen_phone_numbers(m),
      gen_emails(m),
      gen_contacts(m)]
  end
  [headers] + data
end

prawn_document(:page_layout => :landscape) do |pdf|

  pdf.text "#{team_name} Full Roster", :size=>9, :align => :center
  pdf.move_down 5
  pdf.text "Generated #{Time.now.strftime("%D %H:%M")} by @#{current_membership.user_name} - #{team_name} Confidential", :size => 8, :align => :center

  pdf.move_down 15

  pdf.font_size 8

  table_opts = {:header        => true,
                :column_widths => {0=>90, 1=>130, 2=>130, 3=>170 },
                :row_colors    => ["ffffff", "eeeeee"]}

  pdf.table(gen_array, table_opts)  do
    row(0).style(:font_style => :bold, :background_color => 'cccccc')
  end

  footer_string = "#{team_name} Confidential - Page <page> of <total>"

  options = {
          :at => [0, 0],
          :width => 150,
          :align => :right
          }

  pdf.number_pages footer_string, options

end