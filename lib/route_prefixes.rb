module RoutePrefixes
  # get the set of route prefixes for this app
  # basically the set of urls that are reserved by the application
  #
  # i.e. [ 'assets', 'news' ] etc.
  
  PREFIXES = 
    Rails.application.routes.routes.map do |r| 
      r.path.spec.to_s.split('(').first.split('/').second
    end.select(&:itself).to_set
end
