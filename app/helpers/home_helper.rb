module HomeHelper

  def button_list(list)
    result = list.map do |el|
      <<-HTML
        <button class='btn btnAdd btnClk btn-primary' data-el='#{el}'>
          #{el.gsub('_',' ').titleize}
        </button>
      HTML
    end
    raw result.join('<br/>')
  end

end