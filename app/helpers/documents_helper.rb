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

  def render_protocols_table(docs)
    if docs.any?
      render partial: 'protocol_document_groups', locals: {document_groups: docs }
    else
      no_docs('Inga möten av den här typen finns uppladdade.')
    end
  end

  def render_other_table(docs)
    if docs.any?
      render partial: 'documents/other_document_groups', locals: {document_groups: docs }
    else
      no_docs('Inga övriga dokumentsamlingar finns uppladdade.')
    end
  end

end
