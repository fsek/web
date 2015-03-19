crumb :document_groups do
  link 'Dokumentsamlingar', DocumentGroup
  parent :admin
end

crumb :show_document_group do |document_group|
  link document_group.name, document_group
  parent :document_groups
end

crumb :new_document_group do
  link 'Skapa ny', new_document_group_path
  parent :document_groups
end
