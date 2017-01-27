function markdown() {
  $('[id^=wmd-button-bar]').html(''); // Turbolinks 5 fix

  return $('textarea.wmd-input').each(function(i, input) {
    var attr, converter, editor, help;
    attr = $(input).attr('id').split('wmd-input')[1];
    converter = new Markdown.Converter();
    Markdown.Extra.init(converter);
    help = {
      handler: function() {
        window.open('http://daringfireball.net/projects/markdown/syntax');
        return false;
      },
      title: "<%= I18n.t('components.markdown_editor.help', default: 'Markdown Editing Help') %>"
    };
    editor = new Markdown.Editor(converter, attr, help);
    return editor.run();
  });
};

$(document).on('turbolinks:load', markdown);
