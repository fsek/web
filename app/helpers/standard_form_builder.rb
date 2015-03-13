class StandardFormBuilder < ActionView::Helpers::FormBuilder
  def self.default_fields(method_name)
    define_method(method_name) do |attribute, *args|
      options = args.detect{ |a| a.is_a?(Hash) } || {}
      content = @template.content_tag(:label, super(attribute, options), class: 'input')
      content << errors(attribute)
    end
  end

  # Map our defualt_fields method onto the super methods.
  # Doens't cover some of the field types - like select, collection select etc.
  field_helpers.each do |field|
    default_fields(field)
  end

  def select(attribute, choices = nil, options={}, html_options={})
    content = @template.content_tag(:label, class: 'select') do
      @template.select(@object_name, attribute, choices, objectify_options(options), @default_options.merge(html_options)) +
      @template.content_tag(:i)
    end
    content << errors(attribute) 
  end

  def check_box(attribute, options={}, checked = '1', unchecked = '0')
    content = @template.content_tag(:label, class: 'toggle') do
      super(attribute, options, checked, unchecked) +
      @template.content_tag(:i) + 
      options[:label]
    end
    content << errors(attribute) 
  end

  def file_field(attribute, options={})
    options[:onchange] = 'this.parentNode.nextSibling.value = this.value'
    content = @template.content_tag(:label, for: 'file', class: 'input input-file') do
      @template.content_tag(:div, super(attribute, options) + 'Välj fil', class: 'button bg-color-orange') +
      @template.content_tag(:input, '', placeholder: 'Dokument att ladda upp (endast pdf)', readonly: true)
    end
    content << errors(attribute) 
  end

  private 
    def errors(attribute)
      attribute = attribute[0..-4].to_sym if attribute.to_s.ends_with? '_id'

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
      end
    end

end
