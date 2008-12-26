require 'kontrol'

class KWiki < Kontrol::Application

  class Page
    attr_accessor :name, :body

    def initialize(name, body)
      @name, @body = name.chomp('.md'), body
    end

    def title
      name.gsub('_', ' ')
    end

    def html
      RubyPants.new(BlueCloth.new(body).to_html).to_html
    end

  end

  class PageHandler
    def read(name, data)
      Page.new(name, data)
    end

    def write(page)
      page.body
    end    
  end

  def pages
    store['pages'] ||= GitStore::Tree.new
  end

  def diff_line_class(line)
    case line[0, 1]
    when '+' then 'added'
    when '-' then 'deleted'
    end
  end 

end
