# Form builder for bootstrap 3
# - Horizontal Layout
# - Single Column
class BsHorizSingleBuilder < ActionView::Helpers::FormBuilder

  def initialize(name, *args)
    @label_width = args.last[:label_width] || 3
    @input_width = 12 - @label_width
    args.last[:html] ||= {}
    args.last[:html][:class] = 'form-horizontal'
    super(name, *args)
  end

  def date_field(name, *args)
    @template.content_tag(:div, class: 'form-group') do
      merged_args = args.reduce({}) {|a,v| a.merge!(v) if v.is_a?(Hash); a}
      lbl = merged_args[:label] || name.to_s.titleize
      label(name, lbl, class: "col-ms-#{@label_width} control-label") +
      @template.content_tag(:div, class: "col-ms-#{@input_width}") do
        super(name, merged_args.merge({class: 'form-control'}))
      end
    end
  end

  def file_field(name, *args)
    merged_args = args.reduce({}) {|a,v| a.merge!(v) if v.is_a?(Hash); a}
    gid    = (val = merged_args.delete(:gid)) ? {id: val} : {}
    gclass = {class: "form-group #{merged_args.delete(:gclass)}"}
    opts   = gid.merge(gclass)
    @template.content_tag(:div, opts) do
      lbl = merged_args[:label] || name.to_s.titleize
      label(name, lbl, class: "col-ms-#{@label_width} control-label") +
      @template.content_tag(:div, class: "col-ms-#{@input_width}") do
        existing_attachment_link +
        super(name, merged_args)
      end
    end
  end

  def text_field(name, *args)
    merged_args = args.reduce({}) {|a,v| a.merge!(v) if v.is_a?(Hash); a}
    gid    = (val = merged_args.delete(:gid)) ? {id: val} : {}
    gclass = {class: "form-group #{merged_args.delete(:gclass)}"}
    opts   = gid.merge(gclass)
    @template.content_tag(:div, opts) do
      lbl = merged_args[:label] || name.to_s.titleize
      label(name, lbl, class: "col-ms-#{@label_width} control-label") +
      @template.content_tag(:div, class: "col-ms-#{@input_width}") do
        super(name, merged_args.merge({class: 'form-control'}))
      end
    end
  end

  def select(name, args, options = {}, html_options = {})
    lbl = options.delete(:label) || name.to_s.titleize
    @template.content_tag(:div, class: 'form-group') do
      label(name, lbl, class: "col-ms-#{@label_width} control-label") +
      @template.content_tag(:div, class: "col-ms-#{@input_width}") do
        html_options.merge!({class: 'form-control'})
        super(name, args, options, html_options)
      end
    end
  end

  def submit_btn(label)
    @template.raw <<-EOF
    <div class="form-group">
      <div class="col-ms-offset-#{@label_width} col-ms-#{@input_width}">
        <input type="submit" value="#{label}" class="btn btn-primary">
      </div>
    </div>
    EOF
  end

  def horizontal_check_boxes(name, args, txt_method, val_method, options = {})
    lbl = options.delete(:label) || name.to_s.titleize
    @template.content_tag(:div, class: 'form-group') do
      label(name, lbl, class: "col-ms-#{@label_width} control-label") +
      @template.content_tag(:div, class: "col-ms-#{@input_width}") do
        val = args.map do |obj|
          @template.content_tag(:label, class: 'checkbox-inline') do
            @template.raw "<input type='checkbox' value='#{obj.send(val_method)}'> #{obj.send(txt_method)} "
          end
        end.join
        @template.raw(val)
      end
    end
  end

  private

  def existing_attachment_link
    return @template.raw('') unless @object_name == 'mem_cert_form'
    return @template.raw('') if @object.usr_cert.blank?
    return @template.raw('') if @object.usr_cert.attachment_file_name.blank?
    blk = <<-ERB
      <div style='margin-bottom: 4px;'>
        <a href='#{@object.usr_cert.attachment.url}' target="_blank">current file</a>
        (delete <input type='checkbox' name='mem_cert_form[del_attachment]'>)
      </div>
    ERB
    @template.raw blk
  end

end