module DocumentGroupsHelper
  def render_document_group_table(docs)
    if docs.any?
      render partial: 'document_groups/other_document_groups', locals: {document_groups: docs }
    else
      no_docs('Inga övriga dokumentsamlingar finns uppladdade.')
    end
  end

end
