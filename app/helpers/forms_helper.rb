module FormsHelper

  # ----- form_for builder invocations -----
  def bs_horiz_single_form_for(object, options = {}, &block)
    options[:builder] = BsHorizSingleBuilder
    form_for(object, options, &block)
  end

  def bs_vert_multi_form_for(object, options = {}, &block)
    options[:builder] = BsVertMultiBuilder
    form_for(object, options, &block)
  end

  def coderwall_form_for(object, options = {}, &block)
    options[:builder] = CoderwallFormBuilder
    form_for(object, options, &block)
  end

  # ----- helper methods -----

  # Creates a div wrapper with class 'input-group'
  def input_group(options={}, &block)
    content = capture(&block)
    update_options_with_class!(options, 'input-group')
    content_tag(:div, content, options)
  end

  # Creates a div wrapper with class 'form-group'
  def form_group(options ={}, &block)
    content = capture(&block)
    update_options_with_class!(options, 'form-group')
    content_tag(:div, content, options)
  end

  # Creates a fieldset with class from current_namespace (used internally in our project)
  def form_fieldset(&block)
    klass = "#{current_namespace}-fieldset"
    content_tag(:fieldset, capture(&block), class: klass)
  end

  # Creates a legend tag
  def form_legend(content, options ={})
    content_tag(:legend, content, options)
  end

  # Creates a div wrapper with class 'input-group'
  def form_input_group(&block)
    content_tag(:div, capture(&block), class: 'input-group')
  end

  # Creates a div wrapper with class 'checkbox'
  def form_checkbox(&block)
    content_tag(:div, capture(&block), class: 'checkbox')
  end

  # Show the error messages on :base for a record
  def error_messages_for(object)
    if object.errors[:base].any?
      message = object.errors[:base].first
      %{<div class="text-danger">#{message}</div>}.html_safe
    end
  end

  # Update an options hash with a given :class value
  def update_options_with_class!(options, klass)
    options[:class] ||= ''
    options[:class] << " #{klass}"
    options
  end

end


