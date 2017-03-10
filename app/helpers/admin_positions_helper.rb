module AdminPositionsHelper
  def delete_position_button(id)
    url = "/admin/position_index/#{id}"
    cls = 'btn btn-xs btn-danger'
    msg = 'Are you sure?'
    "<a data-confirm='#{msg}' class='#{cls}' data-method='delete' href='#{url}'>Delete</a>"
  end
end