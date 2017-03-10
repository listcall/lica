module WikiPagesHelper

  def wiki_nav_path
    page = @page.try(:name)
    name = @wiki.name
    wid  = params[:wiki_id]
    base_lnk = "<a href='/wikis'>wikis</a>"
    wiki_lnk = page ? "<a href='/wikis/#{wid}/pages'>#{name}</a>" : name
    [base_lnk, wiki_lnk, page].select(&:present?).join(' / ')
  end

  def wiki_repos
    return '' if @wikis.blank?
    wiki_list = @wikis.map do |wiki|
      "<a href='/wikis/#{wiki.id}/pages'>#{wiki.name}</a><br/>"
    end.join
    "<b>Wikis</b><br/>#{wiki_list}<p></p>"
  end

  def wiki_pages
    return '' if @pages.blank?
    page_list = @pages.map do |page|
      "<a href='/wikis/#{@wiki.id}/pages/#{page.url_path}'>#{page.url_path}</a><br/>"
    end.join
    "<b>Pages</b><br/>#{page_list}<p></p>"
  end

  def wiki_index_nav
    new     = "<a href='/wikis/#{@wiki.id}/pages/new?cancel=/wikis/#{@wiki.id}/pages'>New</a>"
    new
  end

  def wiki_show_nav
    new     = "<a href='/wikis/#{@wiki.id}/pages/new?cancel=/wikis/#{@wiki.id}/pages'>New</a>"
    edit    = "<a href='/wikis/#{@wiki.id}/pages/#{@pname}/edit'>Edit</a>"
    rename  = "<a href='/wikis/#{@wiki.id}/pages/#{@pname}/rename'>Rename</a>"
    history = "<a href='/wikis/#{@wiki.id}/pages/#{@pname}/history'>History</a>"
    delete  = "<a href='/wikis/#{@wiki.id}/pages/#{@pname}/delete'>Delete</a>"
    "#{new} | #{edit} | #{rename} | #{history} | #{delete}"
  end

  def wiki_edit_nav
    <<-EOF
    <form action="/wikis/#{@wiki.id}/pages/#{@pname}" method='post'>
      <input name="_method" type='hidden' value='put'>
      <input name='authenticity_token' type='hidden' value='#{form_authenticity_token}'>
      <input size=40 name='comment' placeholder='#{PLACEHOLDER}'/>
      <input type='submit' value='Save'/> | <a href='/wiki/#{@page.url_path}/show'>Cancel</a>
    EOF
  end

  def wiki_edit_content
    <<-EOF
    <textarea rows=25 cols=80 name='text_area'>#{@page.raw_data}</textarea>
    </form>
    EOF
  end

  def wiki_rename_nav
    <<-EOF
    <form action="/wikis/#{@wiki.id}/pages/#{@pname}/reproc" method='post'>
      <input name="_method" type='hidden' value='put'>
      <input name='authenticity_token' type='hidden' value='#{form_authenticity_token}'>
      <input type='submit' value='Save'/> | <a href='/wikis/#{@wiki.id}/pages/#{@pname}'>Cancel</a>
    EOF
  end

  def wiki_rename_content
    <<-EOF
      Current page name: #{@pname}<p></p>
      New page name: <input name='newpage' value='#{@pname}'/>
      </form>
    EOF
  end

  def wiki_new_nav
    <<-EOF
    <form action="/wikis/#{@wiki.id}/pages" method='post'>
      <input name='authenticity_token' type='hidden' value='#{form_authenticity_token}'>
      <input type='submit' value='Save'/> | <a href='#{@cancel}'>Cancel</a>
    EOF
  end

  def wiki_new_content
    <<-EOF
      New page name: <input name='newpage' value=''/>
      <textarea rows=25 cols=80 name='text_area'>New content here...</textarea>
      </form>
    EOF
  end

  def wiki_history_nav
    show    = "<a href='/wikis/#{@wiki.id}/pages/#{@pname}'>Show</a>"
    edit    = "<a href='/wikis/#{@wiki.id}/pages/#{@pname}/edit'>Edit</a>"
    "#{show} | #{edit}"
  end

  def wiki_history_content
    values = @versions.map do |ver|
      author  = ver.author.name
      comment = ver.message
      date    = ver.authored_date.strftime('%Y-%m-%d %H:%M')
      "<tr><td>#{author}</td><td>#{comment}</td><td>#{date}</td></tr>"
    end.join

    <<-EOF
      <h2>History for #{@page.url_path}</h2>
      <table border=1>#{values}</table>
    EOF
  end

end

