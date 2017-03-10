class TeamNavsSvc

  def initialize(current_team, typ)
    @current_team = current_team
    @get_navs     = "team_nav_#{typ}s"
    @set_navs     = "team_nav_#{typ}s="
  end

  def add_obj(nav)
    navs = @current_team.send @get_navs
    navs.add_obj nav
    @current_team.send @set_navs, navs
    @current_team.save
  end

  def update(id: 'TBD', name: 'TBD', value: 'TBD')
    navs = @current_team.send(@get_navs)
    nav  = navs[id]
    return if nav.nil?
    nav.send("#{name}=", value)
    nav.path  = updated_path(nav)  if name == 'type'
    nav.label = updated_label(nav) if name == 'type'
    @current_team.send(@set_navs, navs)
    @current_team.save
  end

  def destroy(item_id)
    if item_id
      navs = @current_team.send @get_navs
      navs.destroy item_id
      @current_team.send(@set_navs, navs)
      @current_team.save
    end
  end

  def sort(list)
    navs = @current_team.send(@get_navs)
    list.each_with_index do |uuid, idx|
      uuid.strip!
      navs[uuid].position = 1 + idx
    end
    @current_team.send @set_navs, navs
    @current_team.save
  end

  private

  def updated_path(nav)
    return '/' if nav.type == '<custom>'
    feature_name = @current_team.team_features[nav.type]
    FEATURES[feature_name.label].menus.first.path
  end

  def updated_label(nav)
    return 'TBD' if nav.type == '<custom>'
    nav.type.split('_').last
  end

end