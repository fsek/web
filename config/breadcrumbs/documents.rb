crumb :documents do |admin_tool|
  link 'Dokument', Document
  parent admin_tool ? :admin : :root
end

crumb :steering_documents do
  link 'Styrdokument', steering_documents_path
  parent :documents
end

crumb :protocol_documents do
  link 'Handlingar och Protokoll', protocols_documents_path
  parent :documents
end

crumb :other_documents do
  link 'Övriga dokument', other_documents_path
  parent :documents
end

crumb :document do |document|
  link document.title, edit_document_path(document)
  parent :documents, true
end

crumb :edit_document do |document|
  link 'Redigera dokument', edit_document_path(document)
  parent :document, document
end

crumb :new_document do
  link 'Skapa nytt', new_document_path
  parent :documents, true
end
