module AdminMenuHelper
  def checkPrivilegies(privilegies)
    auths = []
    privilegies[1].each do |p|
      if can_administrate?(:index, p[0])
        auths.push(p)
      end
    end
    return privilegies[0], auths
  end
end
