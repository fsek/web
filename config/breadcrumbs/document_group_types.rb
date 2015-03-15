crumb :document_group_types do
  link 'Alla dokumentsamlingstyper', DocumentGroupType
  parent :admin
end

crumb :show_document_group_type do |document_group_type|
  link "'#{document_group_type.name}'", document_group_type
  parent :document_group_types
end

crumb :new_document_group_type do
  link 'Skapa ny', new_document_group_type_path
  parent :document_group_types
end

crumb :edit_document_group_type do |document_group_type|
  link 'Redigera', edit_document_group_type_path(document_group_type)
  parent :show_document_group_type, document_group_type
end
