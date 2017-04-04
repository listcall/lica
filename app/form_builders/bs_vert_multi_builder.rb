# Form builder for bootstrap 3
# - Vertical Layout
# - Multi Column
class BsVertMultiBuilder < ActionView::Helpers::FormBuilder

  alias :super_text_field :text_field

  def initialize(name, *args)
    args.last[:html] ||= {}
    args.last[:html][:class] = 'form-vertical'
    super(name, *args)
  end

  def file_field(name, options = {})
    cols    = options.delete(:cols) || 6
    alt_lbl = options.delete(:alt_lbl)
    xlbl    = alt_lbl ? "<div style='float:right;'>#{alt_lbl}</div>" : ''
    @template.content_tag(:div, class: "form-group col-sm-#{cols} #{err_class(name)}") do
      lbl = options.delete(:label) || name.to_s.titleize
      label(name, lbl, class: 'control-label') +
      @template.raw(xlbl) +
      @template.content_tag(:div) do
        super(name, options.merge({class: 'form-control'}))
      end
    end
  end

  def text_field(name, options = {})
    cols    = options.delete(:cols) || 6
    alt_lbl = options.delete(:alt_lbl)
    xlbl    = alt_lbl ? "<div style='float:right;'>#{alt_lbl}</div>" : ''
    @template.content_tag(:div, class: "form-group col-sm-#{cols} #{err_class(name)}") do
      lbl = options.delete(:label) || name.to_s.titleize
      label(name, lbl, class: 'control-label') +
      @template.raw(xlbl) +
      @template.content_tag(:div) do
        super(name, options.merge({class: 'form-control'}))
      end
    end
  end

  def password_field(name, options = {})
    cols    = options.delete(:cols) || 6
    alt_lbl = options.delete(:alt_lbl)
    xlbl    = alt_lbl ? "<div style='float:right;'>#{alt_lbl}</div>" : ''
    @template.content_tag(:div, class: "form-group col-sm-#{cols} #{err_class(name)}") do
      lbl = options.delete(:label) || name.to_s.titleize
      label(name, lbl, class: 'control-label') +
      @template.raw(xlbl) +
      @template.content_tag(:div) do
        super(name, options.merge({class: 'form-control'}))
      end
    end
  end

  def itxt_field(name, options = {})
    cols    = options.delete(:cols)  || 6
    color   = options.delete(:color) || 'blue'
    icon    = options.delete(:fa)    || 'map-marker'
    onclick = options.delete(:onclick)
    alt_lbl = options.delete(:alt_lbl)
    oncl    = onclick ? {onclick: onclick} : {}
    xlbl    = alt_lbl ? "<div style='float:right;'>#{alt_lbl}</div>" : ''
    @template.content_tag(:div, class: "form-group #{err_class(name)} col-sm-#{cols}") do
      lbl = options.delete(:label) || name.to_s.titleize
      label(name, lbl, class: 'control-label') +
      @template.raw(xlbl) +
      @template.content_tag(:div, class: "input-group #{err_class(name)}") do
        opts = {id: "#{options[:id]}-ico", class: 'input-group-addon', style: 'cursor: pointer'}.merge(oncl)
        super_text_field(name, options.merge({class: 'form-control'})) +
        @template.content_tag(:span, opts) do
          @template.raw "<i class='fa fa-#{icon}' style='color: #{color};'></i>"
        end
      end
    end
  end

  def date_time_field(name, options={})
    cols    = options.delete(:cols) || 6
    alt_lbl = options.delete(:alt_lbl)
    xlbl    = alt_lbl ? "<div style='float:right;'>#{alt_lbl}</div>" : ''
    @template.content_tag(:div, class: "form-group #{err_class(name)} col-sm-#{cols}") do
      lbl = options.delete(:label) || name.to_s.titleize
      label(name, lbl, class: 'control-label') +
      @template.raw(xlbl) +
      @template.content_tag(:div, class: 'inline-group') do
        date = object.send("#{name}_date".to_sym)
        time = object.send("#{name}_time".to_sym)
        @template.raw(" <input id='#{name}Date' type='text' name='#{obj_name("#{name}_date")}' placeholder='YYYY-MM-DD' class='form-control date-width' value='#{date}'/>") +
        @template.raw(" <input id='#{name}Time' type='text' name='#{obj_name("#{name}_time")}' placeholder='hh:mm' class='form-control time-width' value='#{time}'/>")
      end
    end
  end

  def text_area(name, options = {})
    cols = options.delete(:cols) || 12
    @template.content_tag(:div, class: "form-group col-sm-#{cols} #{err_class(name)}") do
      lbl = options.delete(:label) || name.to_s.titleize
      label(name, lbl, class: 'control-label') +
      @template.content_tag(:div) do
        super(name, options.merge({class: 'form-control'}))
      end
    end
  end

  def check_boxx(name, options = {})
    cols = options.delete(:cols) || 2
    @template.content_tag(:div, class: "form-group col-sm-#{cols}") do
      lbl = options.delete(:label) || name.to_s.titleize
      label(name, lbl, class: 'control-label') +
      @template.content_tag(:div) do
        super(name, options.merge({class: 'form-control'}))
      end
    end
  end

  def switch_box(name, options={})
    lbl  = options.delete(:label) || name.to_s.titleize
    cols = options.delete(:cols)  || 2
    disp = {style: 'display: block;', class: 'make-switch switch-mini switch-box'}
    disp[:"data-on-label"]  = options.delete(:on_text)  if options[:on_text]
    disp[:"data-off-label"] = options.delete(:off_text) if options[:off_text]
    disp[:"data-on"]        = options.delete(:on_color)  if options[:on_color]
    disp[:"data-off"]       = options.delete(:off_color) if options[:off_color]
    @template.content_tag(:div, class: "form-group col-sm-#{cols}") do
      label(name, lbl, class: 'control-label') +
      @template.content_tag(:div, disp) do
        check_box(name, options)
      end
    end
  end

  def select(name, args, options = {}, html_options = {})
    lbl  = options.delete(:label) || name.to_s.titleize
    cols = options.delete(:cols)  || 6
    @template.content_tag(:div, class: "form-group col-sm-#{cols}") do
      label(name, lbl, class: 'control-label') +
      @template.content_tag(:div) do
        super(name, args, options, html_options.merge({class: 'form-control'}))
      end
    end
  end

  def submit_btn(label)
    @template.raw <<-EOF
    <div class="form-group">
      <div class="col-sm-offset-#{@label_width} col-sm-#{@input_width}">
        <input type="submit" value="#{label}" class="btn btn-primary"/>
      </div>
    </div>
    EOF
  end

  def horizontal_check_boxes(name, args, txt_method, val_method, options = {})
    lbl = options.delete(:label) || name.to_s.titleize
    @template.content_tag(:div, class: 'form-group') do
      label(name, lbl, class: "col-sm-#{@label_width} control-label") +
      @template.content_tag(:div, class: "col-sm-#{@input_width}") do
        val = args.map do |obj|
          @template.content_tag(:label, class: 'checkbox-inline') do
            @template.raw "<input type='checkbox' value='#{obj.send(val_method)}'/> #{obj.send(txt_method)} "
          end
        end.join
        @template.raw(val)
      end
    end
  end

  private

  def err_on?(field)
    opts = ["#{field}", "#{field}_date", "#{field}_time"].map {|x| x.to_s}
    opts.any? { |x| ! object.errors[x].blank? }
  end

  def err_class(field)
    err_on?(field) ? 'has-error' : ''
  end

  def obj_name(name)
    "#{object.class.model_name.param_key}[#{name}]"
  end

end