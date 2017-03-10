module PasswordHelper

  def pagable_icon_for(device)
    if device.pagable
      raw "<i class='fa fa-bullhorn green'></i>"
    else
      raw "<i class='fa fa-ban red'></i>"
    end
  end

end


