require 'date'

namespace :wurbe do
  POSTS_PATH = File.join(File.dirname(__FILE__), 'content', '_posts')

  desc "Create a new blog post"
  task :new_post, :title do |t, args|

    args.with_default(:title => "wurbe #xx")
    today = Date.today.to_s
    new_post_metadata = <<-POST
\n# #{args[:title]}
  #{today}, #{today}
  atomdate: #{Time.now.getgm.strftime("%Y-%m-%dT%H:%M:%SZ")}
  author: #{`git config --get user.name`.strip}
  categories: blog, intalniri
    POST

    File.open("#{POSTS_PATH}.mkd", "a") do |f|
      f.write(new_post_metadata)
    end

    File.open(File.join(POSTS_PATH, args[:title]), 'w') do |f|
      f.write(<<-EOF)
IT WAS AWESOME LOL
      EOF
    end
  end
end
