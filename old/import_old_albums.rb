###
### Mega album import script.
### This code was run on 31 Oct 2016 to import the old image albums.
###

# Ensure no-one runs this by mistake
fail "No! Don't run this code. It's for reference only."

# Pull in the rails app environment
require './config/environment'

# Establish connection to the database
conn = ActiveRecord::Base.connection

# Load items and item attributes
# Note: we are loading from an external database, not the app DB.
items_and_attributes = conn.execute <<-sql
  select I.g_id, I.g_canContainChildren, I.g_summary, I.g_title,
         A.g_parentSequence, F.g_pathComponent
    from gallery.g2_Item I
      join gallery.g2_ItemAttributesMap A on I.g_id = A.g_itemId
      join gallery.g2_FileSystemEntity F on I.g_id = F.g_id
    order by A.g_parentSequence asc
  ;
sql

# Guess the root node
root_id = items_and_attributes.first[0]

# Build tree structure
tree = { root_id => { :title => 'ROOT', :children => { } } }

items_and_attributes.each do |vals|
  id, ccc, summary, title, parents, pathcomp = vals

  next if id == root_id

  # Find parent node
  parent_ids = parents.split('/').map(&:to_i)
  parent_ids.shift # remove root id
  parent = tree[root_id]

  parent_ids.each do |i|
    parent = parent[:children][i]
    parent[:children] ||= {}
  end

  # Add this node to the tree
  parent[:children][id] = {
    :title => title,
    :summary => summary,
    :path => "#{parent[:path]}/#{pathcomp}",
  }
end

# Transform tree to flat table of albums

@album_counter = 0
@picture_counter = 0

def recursive_collect node, album_acc, pictures_acc = nil, name_acc = nil, year = nil, level = 0
  if level == 0
  elsif level == 1
    year = node[:title].to_i
  elsif level >= 2 && node[:children]
    if name_acc
      name_acc = "#{name_acc} - #{node[:title]}"
    else
      name_acc = node[:title]
    end

    album = {
      :year => year,
      :title => name_acc,
      :summary => node[:summary],
      :pictures => []
    }

    album_acc << album
    pictures_acc = album[:pictures]
    @album_counter += 1
  end

  if node[:children]
    node[:children].each do |k, v|
      recursive_collect v, album_acc, pictures_acc, name_acc, year, level + 1
    end
  else
    pictures_acc << node
    @picture_counter += 1
  end
end

album_table = []
recursive_collect tree[root_id], album_table

puts sprintf('Found %d pictures in %d albums.', @picture_counter, @album_counter)

# Insert all the found albums into the database.

BASE = '/oldroot/var/www/gallery_data/albums'

album_table.each do |ia|
  # No empty albums
  if ia[:pictures].empty?
    next
  end

  # Ensure we don't create any duplicates
  result = conn.execute <<-sql
    select 1 from albums a, album_translations t
      where a.id = t.album_id
      and t.locale = 'sv'
      and year(a.start_date) = #{ia[:year]}
      and t.title = #{ActiveRecord::Base.sanitize(ia[:title])}
      limit 1
    ;
  sql

  if result.any?
    next
  end

  description = ia[:summary].present?? ia[:summary] : '_'

  a = Album.new :title_sv => ia[:title],
  		:title_en => ia[:title],
		:description_sv => description,
		:description_en => description,
	        :start_date => Date.parse("#{ia[:year]}-01-02"),
	        :end_date => Date.parse("#{ia[:year]}-12-30")
  begin
    a.save!
  rescue ActiveRecord::RecordInvalid => ex
    binding.pry
  end

  puts "#{a.id}: #{a.title} (#{a.start_date.year})"

  ia[:pictures].each do |ip|
    # If there are still any bad files in the tree at this point, they are ignored.
    filename = File.join(BASE, ip[:path])
    if !File.exist?(filename) || File.directory?(filename)
      next
    end

    # A small attempt to reformat the "summary" to fit the new system.
    photographer_name = ip[:summary] || ''
    photograhper_name = photographer_name.gsub(/Fotografe?r?:? /, '')

    i = Image.new :album_id => a.id,
                  :file => File.new(File.join(BASE, ip[:path])),
		  :photographer_name => photographer_name
    begin
      i.save!
    rescue ActiveRecord::RecordInvalid => ex
      binding.pry
    end

    print '.'
    $stdout.flush
  end

  # No idea if this is needed.
  a.images_count = ia[:pictures].count
  a.save!

  puts ' done'
end

# The cache doesn't work when we insert albums manually, so just nuke it.
Rails.cache.clear

