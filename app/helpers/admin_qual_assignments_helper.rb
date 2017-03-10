module AdminQualAssignmentsHelper
  def qual_check(type, qual, assigs)
    match = assigs.find do |x|
      x.qual_ctype_id == type.id && x.qual_id == qual.id
    end
    status = match.try(:status) || 'unused'
    raw <<-HTML
    <span class='iconSpan' id='chk_#{type.id}_#{qual.id}'>
      #{icon(status, 'unused')  }
      #{icon(status, 'optional')}
      #{icon(status, 'required')}
    </span>
    HTML
  end

  def icon(status, typ)
    obj = opts[typ]
    <<-HTML
      <i class='fa #{obj[:icon]} tClk #{typ}Icon' data-typ='#{typ}' title='#{typ}' style='color: #{obj[:color]}; #{display(status, typ)}'></i>
    HTML
  end

  def opts
    {
      'unused'   => {icon: 'fa-ban'           , color: 'black'       },
      'optional' => {icon: 'fa-check-square'  , color: 'lightblue'   },
      'required' => {icon: 'fa-check-square-o', color: 'green'       },
    }
  end

  def display(status, typ)
    return '' if status == typ
    'display: none;'
  end
end