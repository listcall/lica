# old_serv

# class ServiceDecorator < Draper::Decorator
#   delegate_all
#
#   def display_title
#     name.titleize
#   end
#
#   def partner_vals
#     partners.map {|p| p.team.acronym}.join(',')
#   end
#
#   def partner_vals=(input)
#     i_acros = Array(input)
#     p_acros  = partners.map {|btn_lbl| btn_lbl.team.acronym}
#     p_create = i_acros - p_acros
#     p_delete = p_acros - i_acros
#     partners.match(p_delete).each {|btn_lbl| ServicePartner.find(btn_lbl.id).destroy}
#     p_create.each do |acro|
#       team = Team.find_by_acronym acro
#       ServicePartner.create(service_id: self.id, team_id: team.id)
#     end
#   end
#
#   # ----- partner list -----
#
#   def partner_src
#     model.team.partners.sort_by {|btn_lbl| btn_lbl.acronym}.map {|btn_lbl| {"value" => btn_lbl.acronym, "tebtn_lblt" => btn_lbl.acronym}}.to_json
#   end
#
#   # ----- admin stuff -----
#
#   def delete_button(service)
#     url = "/admin/service_list/#{service.id}"
#     cls = 'btn btn-btn_lbls btn-danger'
#     h.link_to 'Delete', url, :method => :delete, :confirm => 'Are you sure?', :class => cls
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
#     val ? 'btn-success' : 'btn-warning'
#   end
#
#   # ----- Partner Picker -----
#
#   def partner_widget
#     h.raw <<-ERB
#       <a class='inline checkEditable' href='#' data-value='#{partner_vals}' data-name='partner_vals'>
#         #{ partner_vals.gsub(',','<br/>') }
#       </a>
#     ERB
#   end
#
#   def mem_array(role_mems)
#     role_mems.to_a.map {|mem| mem.id.to_s}
#   end
#
#   # ----- Calendar Helper -----
#
#   def calendar_helper
#     # avail = type.cal_avail ? "<a href='/services/#{id}/avail'>Availability</a>" : nil
#     # sched = type.cal_sched ? "<a href='/services/#{id}/sched'>Schedule</a>" : nil
#     # resrc = type.cal_resrc ? "<a href='/services/#{id}/resrc'>Resources</a>" : nil
#     # tmlog = type.cal_tmlog ? "<a href='/services/#{id}/tmlog'>Time Log</a>" : nil
#     # if type.schedule_type == "weekly_rotation"
#     #   [resrc, tmlog].select {|btn_lbl| btn_lbl.present?}.join(' | ')
#     # else
#     #   [avail, sched, tmlog].select {|btn_lbl| btn_lbl.present?}.join(' | ')
#     # end
#     "TBD"
#   end
#
#   # ----- Status Message
#
#   def on_duty_message
#     on_duty = current_on_duty
#     if on_duty.blank?
#       "Nobody"
#     else
#       on_duty.map {|pro| pro.membership.user_name}.join(" | ")
#     end
#   end
#
#   def team_views
#     btns = ServiceType.team_views.select do |view|
#       ok_to_display?(view)
#     end
#     links = btns.map{|btn_lbl| service_link(self, btn_lbl)}.join(" | ")
#     h.raw "<small>#{links}</small>"
#   end
#
#   def mem_actions
#     btns = ServiceType.member_actions.select do |action|
#       ok_to_display?(action)
#     end
#     links = btns.map{|btn_lbl| service_link(self, btn_lbl)}.join(" | ")
#     h.raw "<small>#{links}</small>"
#   end
#
#   # ----- Getting the current Period -----
#
#   def current_period
#     if type.schedule_type == "weekly_rotation"
#       get_weekly_rotation_period
#     else
#       get_other_period
#     end
#   end
#
#   def get_weekly_rotation_period
#     params = current_quarter.merge({service_id: self.id})
#     ServicePeriod.find_or_create(params)
#   end
#
#   def get_other_period
#     period = periods.order(:start => :desc).limit(3).where('start < ?', Time.now).first
#     period || ServicePeriod.create({service_id: self.id, start: Time.now})
#   end
#
#   # ----- Getting current On-Duty Providers -----
#
#   def current_on_duty
#     #current_period.providers.on_duty
#     []
#   end
#
#   private
#
#   def ok_to_display?(view)
#     case view
#     when :team_hours   then ok_team_hours?
#     when :mem_signin   then ok_signin?
#     when :mem_signout  then ok_signout?
#     else service_type.send view
#     end
#   end
#
#   def ok_team_hours?
#     service_type.send(:team_hours) && h.manager_rights?
#   end
#
#   def ok_signin?
#     service_type.send(:mem_signin) && ! currently_on_duty?
#   end
#
#   def ok_signout?
#     service_type.send(:mem_signout) && currently_on_duty?
#   end
#
#   def currently_on_duty?
#     mems = current_on_duty.map {|provider| provider.membership}
#     mems.include? h.current_membership
#   end
#
#   def time_scope
#     type.schedule_type == "weekly_rotation" ? "weeks" : "days"
#   end
#
#   def actions(service)
#     id = service.id
#     bu  = "/services/#{id}"
#     uname = h.current_membership.try(:user_name)
#     scope = time_scope
#     avail = "avail_#{scope}"
#     sched = "sched_#{scope}"
#     {
#       :team_avail    => ["#{bu}/#{avail}"          , 'Availability'        ],
#       :team_schedule => ["#{bu}/#{sched}"          , 'Schedule'            ],
#       :team_hours    => ["#{bu}/hours"             , 'Approve Hours'       ],
#       :mem_avail     => ["#{bu}/#{avail}/#{uname}" , 'Update Availability' ],
#       :mem_schedule  => ["#{bu}/#{sched}/#{uname}" , 'View Schedule'       ],
#       :mem_hours     => ["#{bu}/hours/#{uname}"    , 'Update Hours'        ],
#       :mem_signin    => ["#{bu}/signin"            , 'Sign-In'             ],
#       :mem_signout   => ["#{bu}/signout"           , 'Sign-Out'            ],
#     }
#   end
#
#   def service_link(service, type)
#     url, label = actions(service)[type]
#     "<a href='#{url}'>#{label}</a>"
#   end
#
# end