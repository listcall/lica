PLACEHOLDER = 'Add a short note to explain this change. (Optional)'

class WikiPagesController < ApplicationController

  before_action :authenticate_reserve!

  def index
    setenv
  end

  def show
    setenv
    @page  = @repo.page(params[:id])
    @pname = params[:id]
  end

  def new
    setenv
    @cancel  = params['cancel']
  end

  def create
    setenv
    msg = "Created #{params['newpage']} (markdown)"
    @repo.gollum.write_page(params['newpage'], :markdown, params['text_area'], commit(msg))
    redirect_to "/wikis/#{@wiki.id}/pages/#{params['newpage']}", :notice => 'Successful Creation'
  end

  def edit
    setenv
    @page  = @repo.page(params[:id])
    @pname = params[:id]
  end

  def update
    setenv
    @page  = @repo.page(params[:id])
    @pname = params[:id]
    msg = params['comment'].blank? ? "Updated #{@page.name} (#{@page.format})" : "#{params['comment']} (#{@page.format})"
    @repo.gollum.update_page(@page, @page.name, @page.format, params['text_area'], commit(msg))
    redirect_to "/wikis/#{@wiki.id}/pages/#{@pname}", :notice => 'Successful Update'
  end

  def destroy
    setenv
    @page  = @repo.page(params[:id])
    @pname = params[:id]
    msg = "Deleted #{@pname}"
    @repo.gollum.delete_page(@page, commit(msg))
    redirect_to "/wikis/#{@wiki.id}/pages", :notice => msg
  end

  def history
    setenv
    @page  = @repo.page(params[:id])
    @pname = params[:id]
    @versions = @page.versions
  end

  def rename
    setenv
    @page  = @repo.page(params[:id])
    @pname = params[:id]
  end

  def reproc
    setenv
    @page  = @repo.page(params[:id])
    @pname = params[:id]
    new_name = params['newpage']
    msg = "Renamed page from #{@pname} to #{new_name}"
    @repo.gollum.rename_page(@page, new_name, commit(msg))
    redirect_to "/wikis/#{@wiki.id}/pages/#{new_name}", :notice => msg

  end

  private

  def commit(message = '')
    {
      message: message,
      name:    current_membership.full_name,
      email:   current_membership.emails.first.address
    }
  end

  def setenv
    @wikis = current_team.wikis
    @wiki  = Wiki.find(params[:wiki_id])
    @repo  = @wiki.repo
    @pages = @repo.pages
  end

  # def get_path(wiki, dir = nil, page = nil)
  #   [wiki, dir, page].delete_if {|x| x.nil?}
  # end

  # def get_dirs(wiki, dir)
  #   return [] unless dir.blank?
  #   wiki.pages.map do |x|
  #     pu = x.url_path
  #     if pu.include? '/'
  #       pu.split('/')[0]
  #     else
  #       ""
  #     end
  #   end.delete_if {|x| x.blank?}.uniq.sort
  # end

  # def get_pages(wiki, dir)
  #   if dir.blank?
  #     wiki.pages.select {|x| ! x.url_path.include? '/'}
  #   else
  #     wiki.pages.select {|x| x.url_path.include? "#{dir}/"}
  #   end
  # end

end
