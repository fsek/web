crumb :root do
  link 'Hem', root_path
end

crumb :admin do
  link 'Administration', root_path
  parent :root
end
