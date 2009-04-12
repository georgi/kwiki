class KWiki
  
  # This class represents a page.
  # Each page has a header, encoded as YAML and a body.
  #
  # Example:
  #     --- 
  #     title: BlueCloth
  #     category: Ruby
  #     tags: markdown, library
  #     created_at: 2008-09-05
  #     updated_at: 2008-09-05
  #     ---
  #     This is the summary, which is by definition the first paragraph of the
  #     article. The summary shows up in list views and rss feeds.  
  #
  class Page

    %w[title author created_at updated_at category tags].each do |name|
      define_method(name) { head[name] }
      define_method("#{name}=") {|v| head[name] = v }
    end

    attr_accessor :name, :src, :head, :body, :summary, :html, :tag_list

    # Initialize a page and set given attributes.
    def initialize(attributes={})
      @head = {}
      @body = ''
      
      attributes.each do |k, v|
        send "#{k}=", v
      end

      parse(src) if src
    end

    # Split up the source into header and body. Load the header as
    # yaml document if present.
    def parse(src)
      if src =~ /\A---(.*?)---(.*)/m
        @head = YAML.load($1)
        @body = $2
      else
        raise ArgumentError, "yaml header not found in source"
      end

      @html = transform(@body)
      @summary = html.split("\n\n")[0]
      @tag_list = tags.to_s.split(",").map { |s| s.strip }

      self
    end

    # Convert to string representation
    def dump
      head.to_yaml + "---" + body
    end

    # Transform the body of this post.
    def transform(src)
      RubyPants.new(BlueCloth.new(src).to_html).to_html
    end

    def eql?(obj)
      self == obj
    end

    def ==(obj)
      if KWiki::Page === obj
        name == obj.name
      end
    end

  end

  class PageHandler
    def read(name, data)
      Page.new(:name => name.chomp('.md'), :src => data)
    end

    def write(page)
      page.body.dump
    end
  end

  GitStore::Handler['md'] = PageHandler.new
end
