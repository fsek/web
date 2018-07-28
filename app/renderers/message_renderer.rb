# frozen_string_literal: true

class MessageRenderer < Redcarpet::Render::HTML
  DEFAULT_OPTIONS = { hard_wrap: true, escape_html: true }.freeze

  def initialize(options)
    super(DEFAULT_OPTIONS.merge(options))
  end

  def header(text, _header_level)
    "<p># #{text}</p>"
  end
end
