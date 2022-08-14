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
                User.human_attribute_name(:email)]
        column_names << EventUser.human_attribute_name(:drink_package_answer) if signup.event.drink_package?
        csv << column_names

        attendees.each do |a|
          row = [a.user,
                  event_user_type(signup, a.user_type),
                  group_str(a),
                  food_preferences_str(a.user),
                  a.answer,
                  a.user.email]
          row << a.drink_package_answer if signup.event.drink_package?
          csv << row
        end
      end
    end
  end
end
