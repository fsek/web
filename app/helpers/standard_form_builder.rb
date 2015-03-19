class StandardFormBuilder < ActionView::Helpers::FormBuilder
  def self.default_fields(method_name)
    define_method(method_name) do |attribute, *args|
      options = args.detect{ |a| a.is_a?(Hash) } || {}
      tag = @template.content_tag(:label, super(attribute, options.except(:help, :label)), class: 'input')
      wrap(heading_label(options) + tag + help_text(attribute, options), options)
    end
  end

  # Map our defualt_fields method onto the super methods.
  # Doens't cover some of the field types - like select, collection select etc.
  field_helpers.each do |field|
    default_fields(field)
  end

  def date_field(attribute, options={})
    options[:class] ||= ''
    options[:class] += ' date_field'
    field = @template.content_tag(:label, class: 'input') do
      @template.content_tag(:i, nil, class: 'icon-append fa fa-calendar') +
      @template.text_field(@object_name, attribute, options.except(:help, :label))
    end
    
    wrap(heading_label(options) + field + help_text(attribute, options), options)
  end

  def select(attribute, choices = nil, options={}, html_options={})
    sel = @template.content_tag(:label, class: 'select') do
      @template.select(@object_name, attribute, choices, objectify_options(options), @default_options.merge(html_options)) +
      @template.content_tag(:i)
    end
    wrap(heading_label(options) + sel + help_text(attribute, options), options)
  end

  def check_box(attribute, options={}, checked = '1', unchecked = '0')
    box = @template.content_tag(:label, class: 'toggle') do
      super(attribute, options, checked, unchecked) +
      @template.content_tag(:i) + 
      options[:placeholder]
    end
    wrap(heading_label(options) + box + help_text(attribute, options), options)
  end

  def file_field(attribute, options={})
    options[:onchange] = 'this.parentNode.nextSibling.value = this.value'
    file = @template.content_tag(:label, for: 'file', class: 'input input-file') do
      @template.content_tag(:div, super(attribute, options) + 'Välj fil', class: 'button bg-color-orange') +
      @template.content_tag(:input, '', placeholder: 'Dokument att ladda upp (endast pdf)', readonly: true)
    end
    wrap(heading_label(options) + file + help_text(attribute, options), options)
  end

  private 
    def root_method(method)
      method.to_s.gsub('_id', '').to_sym
    end

    def errors(attribute)
      attribute = root_method(attribute)

      if @object.errors[attribute].any?
        @template.content_tag(:div, class: 'note note-error') do
          @template.content_tag(:ul) do
            @object.errors.full_messages_for(attribute).each do |msg|
              @template.concat @template.content_tag(:li, msg)
            end
          end
        end
      end
    end

    def heading_label(options)
      if options[:label].present?
        @template.content_tag(:label, options[:label], class: 'label')
      else
        ''.html_safe
      end
    end

    def help_text(attribute, options)
      if options[:help].present?
        @template.content_tag(:div, options[:help], class: 'note') + errors(attribute)
      else
        errors(attribute)
      end
    end

    def wrap(content, options)
      unless options[:section] == false
        @template.content_tag(:section, content)
      else
        content
      end
    end

end
