class Admin::WikiIndexController < ApplicationController

  before_action :authenticate_owner!

  def index
    @title = 'Wiki Index'
    @wikis = WikiDecorator.decorate_collection(current_team.wikis)
  end

  def destroy
    wiki = WikiDecorator.new(Wiki.find(params[:id]))
    name = wiki.display_title
    wiki.destroy
    redirect_to '/admin/wiki_index', :notice => "#{name} was deleted."
  end

  def create
    @wiki  = Wiki.create(valid_params params[:wiki])
    set_default_access_permissions
    if @wiki.valid?
      redirect_to '/admin/wiki_index', notice: "Added #{@wiki.name}"
    else
      redirect_to '/admin/wiki_index', alert:  'There was an error creating the wiki...'
    end
  end

  def update
    name, value = [params[:name], params[:value]]
    wiki = Wiki.find params['pk'].strip
    wiki.send("#{name}=", value)
    wiki.save
    render plain: 'OK', layout: false
  end

  def sort
    params['wiki'].each_with_index do |fid, idx|
      Wiki.find(fid).update_attributes(position: idx+1)
    end
    render plain: 'OK', layout: false
  end

  private

  def valid_params(params)
    params.permit(:name, :type, :team_id)
  end

  def set_default_access_permissions
    v_rights = @wiki.view_rights.set(%w(owner manager active reserve))
    p_rights = @wiki.post_rights.set(%w(owner manager active reserve))
    @wiki.update_attributes view_rights: v_rights, post_rights: p_rights
  end

end
