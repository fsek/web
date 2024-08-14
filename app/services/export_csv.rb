class ExportCSV
  extend EventHelper
  extend UsersHelper

  def self.event_users(attendees, signup)
    if attendees.present? && signup.present?
      CSV.generate(headers: true) do |csv|
        column_names = [User.human_attribute_name(:name),
                EventUser.human_attribute_name(:user_type),
                EventUser.human_attribute_name(:group),
                User.human_attribute_name(:food_preference),
                EventUser.human_attribute_name(:answer),
                User.human_attribute_name(:email),
                EventUser.human_attribute_name(:created_at)]
        column_names << EventUser.human_attribute_name(:drink_package_answer) if signup.event.drink_package?
        csv << column_names

        attendees.each do |a|
          row = [a.user,
                  event_user_type(signup, a.user_type),
                  group_str(a),
                  food_preferences_str(a.user),
                  a.answer,
                  a.user.email,
                  a.created_at]
          row << a.drink_package_answer if signup.event.drink_package?
          csv << row
        end
      end
    end
  end

  def self.volonteers(users)
    CSV.generate(headers: true) do |csv|
      column_names = [User.human_attribute_name(:firstname),
                      User.human_attribute_name(:lastname),
                      User.human_attribute_name(:program),
                      User.human_attribute_name(:start_year)]
      csv << column_names

      users.each do |u|
        unless u.posts.empty?
    		  row = [u.firstname, u.lastname, u.program.to_s, u.start_year.to_s]
		        u.posts.each do |p|
			        row.push(p.title)
            end
          csv << row
        end
      end
    end
  end
end
