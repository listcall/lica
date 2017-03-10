module AdminServiceHelper

  def type_link(type)
    raw link_to type.name, "/admin/service_types/#{type.id}"
  end

  def case_link(service)
    raw link_to service.name, "/admin/service_cases/#{service.id}"
  end

  def svc_delete_button(service, type)
    url = "/admin/#{type}/#{service.id}"
    cls = 'btn btn-xs btn-danger'
    msg = {confirm: 'Are you sure?'}
    button_to 'Delete', url, :method => :delete, :data => msg, :class => cls
  end

  def delete_case_button(service)
    svc_delete_button(service, 'service_cases')
  end

  def delete_type_button(service)
    svc_delete_button(service, 'service_types')
  end

  def svcs_report_delete_button(service_rep)
    url = "/admin/svc_reps/#{service_rep.id}"
    cls = 'btn btn-xs btn-danger'
    msg = {confirm: 'Are you sure?'}
    button_to 'Delete', url, :method => :delete, :data => msg, :class => cls
  end

  def fork_button(report)
    cls = report.forked? ? 'green' : ''
    raw <<-ERB
      <i class='fa fa-code-fork tmplFork #{cls}'></i>
    ERB
  end

  def team_share_button(report)
    cls = report.share_internal? ? 'fa-check-square-o green' : 'fa-square-o'
    raw <<-ERB
      <i class='fa teamShare #{cls}'></i>
    ERB
  end

end