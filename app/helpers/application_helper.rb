module ApplicationHelper

  def feature_enabled(team, key)
    return false if current_membership.manager? && all_owner_features(key)
    return true if %w(Lica_Team Lica_Members Lica_Certs).include? key.to_s
    team.team_features[key.to_s].try(:status) == 'on'
  end

  def all_owner_features(key)
    hash = AdminOpts.menus[key]
    return false if hash.blank?
    hash.all? { |_name, item| item[:view] != 'manager' }
  end

  def can_view_admin(menu)
    return true if current_membership.owner?
    menu[:view] == 'manager'
  end

  def visible_values(values)
    values.select {|menu| can_view_admin(menu)}
  end

  def team_logo
    lbl     = current_team.try(:logo_text)       || 'NO TEAM'
    icon    = current_team.icon_path
    "<a class='navbar-brand' href='/'><img class='icon' style='display: inline;' src='#{icon}'/> #{lbl}</a>"
  end

  def page_flash
    error_flash + notice_flash + alert_flash
  end

  def error_flash
    return '' unless flash[:error]
    gen_flash('error', flash[:error])
  end

  def notice_flash
    return '' unless flash[:notice]
    gen_flash('notice', flash[:notice])
  end

  def alert_flash
    return '' unless flash[:alert]
    gen_flash('alert', flash[:alert])
  end

  def debug_text
    "<b>#{params["controller"]}##{params["action"]}</b>"
  end

  def admin_help_button(page)
    raw help_button('admin', page)
  end

  def member_help_button(page)
    raw help_button('member', page)
  end

  def help_button(type, page)
    <<-ERB
    <a class='help-button' href="/sys/wikis/#{type}_help/#{page}" target='_blank'>
      help
    </a>
    ERB
    ''      # get rid of this after wikis are added...
  end

  # How to use:
  # <%= modal "myId" do %>
  #   <div class='modal-body'>Body Content...</div>
  #   <div class='modal-footer'>Footer Content...</div>
  # <% end %>
  def modal(id, title = '', &block)
    raw <<-HTML
    <div class="modal fade" id="#{id}" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h4 id='modal-title' class="modal-title">#{title}</h4>
          </div>
          #{capture(&block)}
        </div>
      </div>
    </div>
    HTML
  end

end
