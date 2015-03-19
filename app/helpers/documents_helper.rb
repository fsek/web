module DocumentsHelper
  def no_docs(msg)
    return content_tag(:p, content_tag(:strong, msg))
  end

  def render_steering_table(docs)
    if docs.any?
      render partial: 'steering_documents', locals: { documents: docs }
    else
      no_docs('Inga styrdokument av den här typen finns uppladdade.')
    end
  end

  def render_protocols_table(docs, year_spacer=true)
    if docs.any?
      render partial: 'protocol_document_groups', locals: {document_groups: docs, year_spacer: year_spacer }
    else
      no_docs('Inga möten av den här typen finns uppladdade.')
    end
  end

  def render_documents_table(docs)
    if docs.any?
      render partial: 'documents/documents', locals: {documents: docs }
    else
      no_docs('Inga dokument finns uppladdade.')
    end
  end

end
