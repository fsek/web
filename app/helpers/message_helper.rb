# frozen_string_literal: true

module MessageHelper
  MARKDOWN_EXTENSIONS = {
    quote: true,
    autolink: true,
    underline: true,
    lax_spacing: true,
    no_intra_emphasis: true,
    fenced_code_blocks: true,
    space_after_headers: true
  }.freeze

  API_OPTIONS = { link_attributes: { class: 'external', target: '_system' } }.freeze

  def self.markdown(text)
    MarkdownHelper.sanitize(renderer.render(text)) if text.present?
  end

  def self.markdown_api(text)
    MarkdownHelper.sanitize(api_renderer.render(text)) if text.present?
  end

  def self.renderer
    Redcarpet::Markdown.new(MessageRenderer.new({}), MARKDOWN_EXTENSIONS)
  end

  def self.api_renderer
    Redcarpet::Markdown.new(MessageRenderer.new(API_OPTIONS), MARKDOWN_EXTENSIONS)
  end

  def admin_message_image_url(message)
    download_image_admin_message_url(message)
  end

  def message_destroy_link(message)
    link_to(admin_message_path(message),
            method: :delete,
            class: '',
            data: { confirm: t('helper.message.destroy_message') }) do
      fa_icon('trash')
    end
  end

  def message_edit_link(message)
    link_to(edit_admin_message_path(message), class: '') do
      fa_icon('pencil')
    end
  end

  def message_receivers(message)
    tag(:br) + t('helper.message.to') + message.group_names
  end

  def message_form_params(edit, message)
    if edit
      [:admin, message]
    else
      [:admin, message.introduction, message]
    end
  end

  def group_preset(preset, introduction)
    if preset == Group::REGULAR
      introduction.groups.regular
    elsif preset == Group::MISSION
      introduction.groups.missions
    end
  end
end
