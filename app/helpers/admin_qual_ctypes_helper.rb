module AdminQualCtypesHelper
  def delete_qual_ctype_button(id)
    url = "/admin/qual_ctypes/#{id}"
    cls = 'btn btn-xs btn-danger'
    msg = { confirm: 'Are you sure?'}
    raw link_to 'Delete', url, method: :delete, data: msg, class: cls
  end

  def cert_required_helper(qual_ctype)
    colors  = 'data-on="warning" data-off="primary"'
    icons   = 'data-on-label="<b>yes</b>" data-off-label="<b>no</b>"'
    checked = qual_ctype.required? ? "checked='checked'" : ''
    raw <<-HTML
      <div id='require_#{qual_ctype.id}' class="make-switch switch-mini requireToggle" #{colors} #{icons}>
          <input #{checked} type="checkbox">
      </div>
    HTML
  end

  def cert_options_helper(ctype)
    exp_chk, exp_act = ctype.expirable?   ? ['checked', 'active'] : ['', '']
    com_chk, com_act = ctype.commentable? ? ['checked', 'active'] : ['', '']

    check2 = <<-HTML
    <label class='btn btn-primary btn-xs #{exp_act} expCk' data-title='expirable?'>
      <input type='checkbox' id="qcExp_#{ctype.id}" class='expChk' #{exp_chk}><i class='fa fa-calendar'></i>
    </label>
    HTML

    green_cal = <<-HTML
    <i class='fa fa-calendar green'></i>
    HTML

    raw <<-HTML
    <div class='btn-group' data-toggle="buttons">
      <label class='btn btn-primary btn-xs #{com_act} comCk' data-title='commentable?'>
        <input type='checkbox' id="qcCom_#{ctype.id}" class='comChk' #{com_chk}><i class='fa fa-comment'></i>
      </label>
      #{ check2 unless ctype.has_attendance?}
    </div>
    #{ green_cal if ctype.has_attendance?}
    HTML
  end

  def cert_expirable_helper(qual_ctype)
    colors  = 'data-on="warning" data-off="primary"'
    icons   = 'data-on-label="<b>yes</b>" data-off-label="<b>no</b>"'
    checked = qual_ctype.expirable? ? "checked='checked'" : ''
    raw <<-HTML
      <div id='require_#{qual_ctype.id}' class="make-switch switch-mini expirableToggle" #{colors} #{icons}>
          <input #{checked} type="checkbox">
      </div>
    HTML
  end
end