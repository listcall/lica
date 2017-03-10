module AdminQualsHelper
  def delete_qual_button(id)
    url = "/admin/quals/#{id}"
    cls = 'btn btn-xs btn-danger'
    msg = { confirm: 'Are you sure?'}
    raw link_to 'Delete', url, method: :delete, data: msg, class: cls
  end
end