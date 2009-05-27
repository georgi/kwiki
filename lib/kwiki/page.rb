class KWiki
  
  # This class represents a wiki page.
  # Each page has a header, encoded as YAML and a body.
  #
  # Example:
  #     --- 
  #     title: BlueCloth
  #     category: Ruby
  #     tags: markdown, library
  #     ---
  #     This is the summary, which is by definition the first paragraph of the
  #     article. The summary shows up in list views and rss feeds.  
  #
  class Page

    %w[title author category tags].each do |name|
      define_method(name) { head[name] }
      define_method("#{name}=") {|v| head[name] = v }
    end

    attr_reader :src, :body, :head, :summary, :html, :tag_list

    # Initialize a page and set given attributes.
    def initialize(attributes={})
      @head = {}
      @body = ''

      set attributes
      
      raise "title is required" if title.nil?
    end

    # Set attributes by given hash
    def set(attributes)
      attributes.each do |k, v|
        send "#{k}=", v
      end
    end

    # Set the source and parse
    def src=(src)
      @src = src
      parse(src)
    end

    # Set the body
    def body=(body)
      @body = body
      @html = transform(@body)
      @summary = @html.split("\n\n")[0]
    end
    
    # Load the header as yaml document.
    def head=(head)
      @head = head
      @tag_list = tags.to_s.split(",").map { |s| s.strip }
    end

    # Split up the source into header and body. 
    def parse(src)
      if src =~ /\A---(.*?)---(.*)/m
        self.head = YAML.load($1)
        self.body = $2
      else
        raise ArgumentError, "yaml header not found in source"
      end
    end

    def to_param
      title.gsub(/ /, '_')
    end

    # Convert to string representation
    def dump
      head.to_yaml + "---\n" + body
    end

    # Transform the body of this post.
    def transform(src)
      RubyPants.new(BlueCloth.new(src).to_html).to_html
    end

    def eql?(obj)
      self == obj
    end

  end

  class PageHandler
    def read(data)
      Page.new(:src => data)
    end

    def write(page)
      page.dump
    end
  end
end
