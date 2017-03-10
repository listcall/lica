# helpers to generate X-Editable form elements
# see http://vitalets.github.io/x-editable

module XeditableHelper

  # generates Xeditable Text element
  # http://vitalets.github.io/x-editable/docs.html#text
  def xeTxt(cls:'', id:'', pk:'', url:'', name:, val:)
    ecl  = " class='inline #{cls}'"
    eid  = opt_arg(id, 'id')
    epk  = opt_arg(pk, 'data-pk')

    dtyp  = " data-type='text'"
    dnam  = " data-name='#{name}'"
    durl  = opt_url(url, pk)

    raw <<-EOF
    <a href='#'#{ecl}#{eid}#{epk}#{dnam}#{durl}#{dtyp}>
      #{val}
    </a>
    EOF
  end

  # generates Xeditable Select element
  # http://vitalets.github.io/x-editable/docs.html#select
  def xeSel(cls:'', id:'', pk:'', name:, val:, src:)
    ecl  = " class='inline #{cls}'"
    eid  = opt_arg(id, 'id')
    epk  = opt_arg(pk, 'data-pk')

    dtyp  = " data-type='select'"
    dnam  = " data-name='#{name}'"
    dval  = " data-value='#{val}'"     # "xyz"
    dsrc  = " data-source='#{src}'"    # [{value:1, text:"xyz"},{...}]

    raw <<-EOF
    <a href='#'#{ecl}#{eid}#{epk}#{dsrc}#{dnam}#{dval}#{dtyp}>
    </a>
    EOF
  end

  # generates Xeditable Checklist element
  # http://vitalets.github.io/x-editable/docs.html#checklist
  def xeCkl(cls:'', id:'', pk:'', name:, val:, src:, place:'top')
    ecl  = " class='inline #{cls}'"
    eid  = opt_arg(id, 'id')
    epk  = opt_arg(pk, 'data-pk')

    dtyp  = " data-type='checklist'"
    dnam  = " data-name='#{name}'"
    dval  = " data-value='#{val}'"    # [3,5]
    dsrc  = " data-source='#{src}'"   # [{value:1, text:"xyz"},{...}]
    dplc  = " data-placement='#{place}'"

    raw <<-EOF
    <a href='#'#{ecl}#{eid}#{epk}#{dsrc}#{dnam}#{dval}#{dtyp}#{dplc}>
    </a>
    EOF
  end

  private

  def opt_arg(value, key)
    value.blank? ? '' : " #{key}='#{value}'"
  end

  def opt_url(url, pk)
    return '' if pk.blank? || url.blank?
    " data-url='#{url}/#{pk}'"
  end

end

