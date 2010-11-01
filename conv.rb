# unless ARGV[0] == "--run"
  # puts "DANGER! Read the source before running."
  # exit 1
# end

require 'rubygems'
require 'fileutils'
require 'yaml'

require 'fluffy_barbarian'

FileUtils.rm_rf("content/_posts2")
FileUtils.mkdir_p("content/_posts2")

File.open("content/_posts.mkd", "w") do |f|
  Dir["content/_posts/*"].sort.each do |path|
    basename = path.gsub(/.*\//, "")
    date = basename.split("-")[0..2].join("-")

    file = File.read(path)
    parts = file.split(/---\s*/).tidy
    meta = YAML::load(parts.first)
    contents = parts.last

    slug = meta["filename"]
    autoslug = meta["title"].parameterize
    title = meta["title"].downcase.tidy
    exact = parts.first.split("\n").find{|l| l.include? "created_at"}.split(": ").last
    date_parts = exact.split(" ")
    exact = "#{date_parts[0]}T#{date_parts[1]}#{date_parts[2]}"

    File.open("content/_posts2/#{title}.textile", "w") do |ff|
      ff << contents
    end

    f << "# #{title}\n"
    lines = ["#{date}, #{date}", "atom-date: #{exact}"]
    lines << "slug: #{slug}" if slug != autoslug
    lines << "author: #{meta["author"]}"
    lines << "categories: #{meta["categories"].join(", ")}"
    f << lines.map {|l| "  #{l}"}.join("\n")
    f << "\n\n"
  end
end
