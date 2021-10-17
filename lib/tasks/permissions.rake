namespace "permissions" do
  desc "Loading all models and their related controller methods inpermissions table."
  task(load: :environment) do
    avoid_methods = ["can_administrate?", "authorize_admin!",
      "load_permissions", "model_name",
      "alert_create", "alert_update",
      "alert_destroy", "current_admin_ability"]
    arr = []
    # load all the controllers
    controllers = Dir.new("#{Rails.root}/app/controllers").entries
    controllers.each do |entry|
      if entry =~ /_controller/ && entry != "application_controller.rb"
        # check if the controller is valid
        arr << entry.camelize.gsub(".rb", "").constantize
      elsif /^[a-z]*$/.match?(entry) # namescoped controllers
        Dir.new("#{Rails.root}/app/controllers/#{entry}").entries.each do |x|
          if x =~ /_controller/ && entry != "application_controller.rb"
            arr << "#{entry.titleize}::#{x.camelize.gsub(".rb", "")}".constantize
          end
        end
      end
    end

    arr.each do |controller|
      # only that controller which represents a model
      if controller.permission
        puts "Permissions for: #{controller.permission}"
        # create a universal permission for that model. eg 'manage User' will allow all actions on User model.
        write_permission(controller.permission, "manage") # add permission to do CRUD for every model.
        controller.action_methods.each do |method|
          if !avoid_methods.include?(method) && method =~ /^([A-Za-z\d*]+)+(\w*)+([A-Za-z\d*]+)$/ # add_user, add_user_info, Add_user, add_User
            _, cancan_action = eval_cancan_action(method)
            write_permission(controller.permission, cancan_action)
          end
        end
      end
    end
  end
end

# this method returns the cancan action for the action passed.
def eval_cancan_action(action)
  case action.to_s
    when "index"
      name = "list"
      cancan_action = "index" # <strong>let the cancan action be the actual method name</strong>
    when "new", "create"
      name = "create and update"
      cancan_action = "create"
    when "show"
      name = "view"
      cancan_action = "view"
    when "edit", "update"
      name = "create and update"
      cancan_action = "update"
    when "delete", "destroy"
      name = "delete"
      cancan_action = "destroy"
    else
      name = action.to_s
      cancan_action = action.to_s
  end
  [name, cancan_action]
end

# check if the permission is present else add a new one.
def write_permission(model, cancan_action)
  Permission.find_or_create_by(subject_class: model, action: cancan_action)
end
