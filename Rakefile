require 'date'

namespace :wurbe do
  POSTS_PATH = File.join(File.dirname(__FILE__), 'content', '_posts')

  desc "Create a new blog post"
  task :new_post, :title do |t, args|

    args.with_default(:title => "wurbe #xx")
    title = args[:title].strip.downcase
    today = Date.today.to_s
    new_post_filename = File.join(POSTS_PATH, "#{title}.textile")
    new_post_metadata = <<-POST
\n# #{title}
  #{today}, #{today}
  atomdate: #{Time.now.getgm.strftime("%Y-%m-%dT%H:%M:%SZ")}
  author: #{`git config --get user.name`.strip}
  categories: blog
    POST

    File.open("#{POSTS_PATH}.mkd", "a") do |f|
      f.write(new_post_metadata)
    end
    puts "√ Added #{title} to post list"

    File.open(new_post_filename, 'w') do |f|
      f.write(<<-EOF)
IT WAS AWESOME LOL
      EOF
    end

    puts "√ Created #{new_post_filename}"
  end
end
