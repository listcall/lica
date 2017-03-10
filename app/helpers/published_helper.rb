module PublishedHelper

  def style_helper(src)
    case src
      when nil then inline_src
      when 'none' then ''
      else ref_src(src)
    end
  end

  private

  def inline_src
    raw "<style>#{render(partial: "style.css")}</style>"
  end

  def ref_src(src)
    raw <<-ERB
    <link rel="stylesheet" type="text/css" href="#{src}">
    ERB
  end

end

