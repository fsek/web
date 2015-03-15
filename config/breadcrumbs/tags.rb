crumb :tags do
  link 'Alla taggar', Tag
  parent :admin
end

crumb :show_tag do |tag|
  link "'#{tag.name}'", tag
  parent :tags
end

crumb :new_tag do
  link 'Skapa ny', new_tag_path
  parent :tags
end

crumb :edit_tag do |tag|
  link 'Redigera', edit_tag_path(tag)
  parent :show_tag, tag
end
