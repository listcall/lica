# old_serv

# class ServiceTypeDecorator < Draper::Decorator
#   delegate_all
#
#   def display_title
#     name.titleize
#   end
#
#   def display_type
#     type.gsub('Fm','')
#   end
#
#   # ----- admin stuff -----
#
#   def delete_button(service)
#     url = "/admin/service_types/#{service.id}"
#     cls = 'btn btn-xs btn-danger'
#     h.link_to 'Delete', url, :method => :delete, :confirm => 'Are you sure?', :class => cls
#   end
#
#   # ----- admin button -----
#
#   def option_button(name, label)
#     clas = "#{btn_klas(name)} btn btn-xs btnCal"
#     data = "data-service_id='#{id}' data-name='#{name}'"
#     h.raw <<-EOF
#     <button type='button' #{data} class='#{clas}'>
#       #{label}
#     </button>
#     EOF
#   end
#
#   # ----- permissions stuff -----
#
#   def role_perm
#     "TBD"
#   end
#
#   def rights_perm
#     "TBD"
#   end
#
#   def btn_klas(type)
#     val = eval type
#     dev_log type
#     dev_log model.id
#     dev_log "#{eval type}"
#     val ? 'btn-success' : 'btn-warning'
#   end
#
# end