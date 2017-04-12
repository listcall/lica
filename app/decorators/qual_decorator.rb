class QualDecorator < ActiveType::Record[Qual]

  include ActiveType::Helpers

  def display_title
    name.titleize
  end

  def display_type
    type.gsub('Fm','')
  end

  # ----- admin stuff -----

  def delete_button(forum)
    url = "/admin/forum_index/#{forum.id}"
    cls = 'btn btn-xs btn-danger'
    h.link_to 'Delete', url, :method => :delete, :confirm => 'Are you sure?', :class => cls
  end

  def rights_permission_button(qual, name)
    bid = "data-qual_id='#{qual.id}'"
    nam = "data-name='#{name}'"
    cls = "class='#{perm_class(name)} btn btn-xs btnRights'"
    h.raw "<button type='button' #{bid} #{nam} #{cls}>#{short_for(name)}</button>"
  end

  private def short_for(name)
            case name.split('_').last
            when 'owner'    then 'OWN'
            when 'manager'  then 'MGR'
            when 'active'   then 'ACT'
            when 'reserve'  then 'RES'
            when 'guest'    then 'GST'
            when 'alum'     then 'ALU'
            else 'TBD'
            end
          end


  # ----- permissions stuff -----

  def role_perm
    'TBD'
  end

  def rights_perm
    'TBD'
  end

  private def perm_class(type)
    type, right = type.split('_')
    perms = case type
              when 'view' then view_rights
              when 'post' then post_rights
                else ''
            end
    perms.has?(right) ? 'btn-success' : 'btn-warning'
  end

end
