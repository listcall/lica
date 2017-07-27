module HomeHelper

  def button_list(list)
    result = list.map do |el|
      <<-HTML
        <button class='btn-link navbar-btn btn-block btnClk' data-el='#{el}'>
          #{el.gsub('_',' ').titleize}
        </button>
      HTML
    end
    raw result.join(' ')
  end

end
