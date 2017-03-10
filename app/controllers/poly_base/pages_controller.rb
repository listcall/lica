class PolyBase::PagesController < ApplicationController

  def index
    @is_index   = true
    @wiki_name  = wiki_name
    @wiki_title = wiki_title
    @wiki_repo  = wiki_repo
    @wiki_path  = wiki_path
    @wiki_repos = @wiki_repo.wiki_repos
  end

  def show
    @wiki_name    = wiki_name
    @wiki_title   = wiki_title
    @wiki_repo    = wiki_repo
    @wiki_repos   = @wiki_repo.wiki_repos
    @page_name    = page_name
    @wiki_path    = wiki_path
    @page_content = @wiki_repos.formatted_page_content(page_name)
  end

  def printable
    @wiki_name    = wiki_name
    @wiki_title   = wiki_title
    @wiki_repo    = wiki_repo
    @wiki_repos   = @wiki_repo.wiki_repos
    @page_name    = page_name
    @wiki_path    = wiki_path
    @page_content = @wiki_repos.formatted_page_content(page_name)
    render layout: false
  end

  def edit
    @prefix       = '../'
    @wiki_name    = wiki_name
    @wiki_title   = wiki_title
    @wiki_repo    = wiki_repo
    @wiki_repos   = @wiki_repo.wiki_repos
    @base_path    = base_path
    @page_name    = page_name
    @wiki_path    = wiki_path
    @page_content = @wiki_repos.raw_page_content(page_name)
    comment       = "Updated by @#{current_user.user_name}"
    attrs         = {label: @page_name, name: @page_name.titleize, content: @page_content, comment: comment}
    @wiki_form    = WikiForm.new(attrs)
  end

  def new
    @wiki_name    = wiki_name
    @wiki_title   = wiki_title
    @base_path    = base_path
    @wiki_path    = wiki_path
    attrs = {name: '', content: '', comment: "Created by @#{current_user.user_name}"}
    @wiki_form = WikiForm.new(attrs)
  end

  def create
    @wiki_name = wiki_name
    wparm = params[:wiki_form]
    @wiki_repo = wiki_repo
    new_label = wparm['name'].parameterize('_')
    attr = {new_page_name: new_label, content: wparm['content'], msg: wparm['comment']}
    @wiki_repo.wiki_repos.create_page attr
    redirect_to "#{wiki_path}/#{new_label}"
  end

  def update
    @wiki_name = wiki_name
    @page_name = page_name
    attrs      = params['wiki_form']
    new_name   = attrs['name']
    content    = attrs['content']
    comment    = attrs['comment']
    @wiki_repo = wiki_repo
    @wiki_repos   = @wiki_repo.wiki_repos
    @wiki_repos.update_page_content(@page_name, content, comment)
    new_label = new_name.parameterize('_')
    @wiki_repos.rename_page(@page_name, new_name) if @page_name != new_label
    redirect_to "#{wiki_path}/#{new_label}"
  end

  def destroy
    @wiki_name = wiki_name
    @page_name = page_name
    @wiki_repo = wiki_repo
    @wiki_repo.wiki_repos.destroy_page(@page_name)
    redirect_to "#{base_path}/#{@wiki_name}"
  end

end
