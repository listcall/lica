module ReportsHelper
  # ----- for BAMRU-roster.csv -----
  def quote(str)
    return nil if str.nil?
    '"' + str.gsub("\n",',') + '"'
  end

  def team_acronym
    @team_acronym ||= current_team.acronym
  end

  def field_record(mem, type)
    case type
      when 'organization'   then team_acronym
      when 'rank'           then mem.rank
      when 'full_name'      then mem.full_name
      when 'first_name'     then mem.first_name
      when 'last_name'      then mem.last_name
      when 'mobile_phone'   then can_view mem.phones.mobile.first, :number
      when 'home_phone'     then can_view mem.phones.home.first  , :number
      when 'work_phone'     then can_view mem.phones.work        , :number
      when 'home_address'   then quote can_view(mem.addresses.home.first, :full_address)
      when 'work_address'   then quote can_view(mem.addresses.work      , :full_address)
      when 'other_address'  then quote can_view(mem.addresses.other     , :full_address)
      when 'home_email'     then can_view(mem.emails.home.first    , :address)
      when 'personal_email' then can_view(mem.emails.personal.first, :address)
      when 'work_email'     then can_view(mem.emails.work.first    , :address)
      when 'other_email'    then can_view(mem.emails.other.first   , :address)
      else
        'TBD'
    end
  end

  def csv_record(mem, fields)
    fields.map {|field| field_record(mem, field)}.join(',')
  end

  # ----- for BAMRU-names.pdf -----
  def download_link(array)
    link_to('Download', "/creports/#{array[2]}", :target => '_blank')
  end

  def report_format(array)
    array[2].split('.').last.upcase
  end

  def report_description(array)
    array[3]
  end

  def can_view(model, method)
    return model.try(method) unless model.respond_to?(:visible?)
    return model.try(method) if model.visible?
    return model.try(method) if manager_rights?
    return model.try(method) if model.user == current_user
    ''
  end

end
