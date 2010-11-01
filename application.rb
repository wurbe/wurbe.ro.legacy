require 'fluffy_barbarian'

class Application < FluffyBarbarian::Application
  def initialize
    @settings = {
      :title         => "wurbe",
      :host          => "wurbe.ro",
      :url           => "http://wurbe.ro",
      :feed          => "http://feeds.feedburner.com/wurbedotro"
    }
  end

  def link_to(name, url)
    "<a href='#{url}'>#{name}</a>"
  end

  def call(env)
    @request  = Rack::Request.new env
    @response = Rack::Response.new

    @url = @request.url

    return [400, {}, []] unless @request.get?

    @index = FluffyBarbarian::Index.new("content/_posts")
    @posts = @index.all
    @meets = @posts.find_all { |p| p[:categories].include? "intalniri" }

    code = 200
    headers = { "Content-Type" => "text/html" }
    path = @request.path_info
    body = case path

           when "/"
             @page  = { :content => render(:content => "index") }
             @title = @settings[:title]
             @slug = "/"

             render :index

           when %r{ / (intalniri|blog|archives) }x
             name = $1
             @title = "#{name} - #{@settings[:title]}"
             @slug = name
             @meets = @posts.find_all { |p| p[:categories].include? "intalniri" }

             @posts = @index.all.each do |post|
               post[:content] ||= render(:content => post[:path])
             end
             render name

           when %r{ /stylesheets/ ([^\.]+) .css }x
             name = $1
             headers['Content-Type'] = 'text/css'
             render "stylesheets/#{name}", :layout => false

           when "/feed.atom"
             @posts = @index.all.each do |post|
               post[:content] ||= render(:content => post[:path])
             end

             headers['Content-Type'] = 'application/atom+xml'
             render :feed, :layout => false

           when %r{^ (.*) / ([^/]+) /* $}x
             splat, slug = $1, $2
             @item = FluffyBarbarian::Page.find(splat, slug) || @index.find(splat, slug)

             return [301, { "Location" => "/" }, ""] unless @item
             return [301, { "Location" => @item[:url] }, ""] if @item[:fuzzy]

             @title = "#{@item[:title]} - #{@settings[:title]}"
             @slug = @item[:slug]

             instance_variable_set("@#{@item[:type]}", @item)
             render @item[:type]

           end

    [code, headers, [body]]
  end
end
