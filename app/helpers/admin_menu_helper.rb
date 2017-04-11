module AdminMenuHelper
  def checkPrivilegies(privilegies)
    auths = []
    hasPrivilegies = false
    privilegies.each do |p|
      if can_administrate?(:index, p[0])
        auths.push(p)
      end
    end
    return auths
  end
end
