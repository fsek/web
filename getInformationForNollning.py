arr = []
PostUser.all.each do |p|
id = p.user_id
postid = p.post_id
user = User.where(id:id).first
food = user.food_preferences
if food.length > 1
# Remove the for some reason multiple occurences of "" in peoples foods
food.delete_if {|x| x == ""}
end
arr.append([user.firstname + " " + user.lastname, user.email,food.join(";"), Post.where(id:postid>
end
arr.each do |e|
obj = '[' + e.join(',') + '],'
# print list like python without weird ruby shit
p e
end


namn, faddergrupp, mailadress, nolla/fadder

arr = []

groups_ids = []
# Number for the relevant nollning, change every year
introduction_nr = 9
groups = Group.all.where(introduction_nr: 9)

groups.each do |g|
groups_ids.append(g.id)
end

groups_ids.all.each do |id|
groupusers = GroupUser.all.where(group_id:id)
groupusers.all.each do |gu|
user = User.where(id:gu.user_id).first
name = user.firstname + ' ' + user.lastname
email = user.email
fadder = gu.fadder
grupp = Group.all.where(id:id).first.name
obj = '[' + email + ',' + name + ',' + grupp + ']'
p obj
end
end
