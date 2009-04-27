class KWiki < Kontrol::Application

  DIR = File.expand_path(File.dirname(__FILE__) + '../../..')

  attr_reader :store, :pages

  def initialize(path)
    super(DIR)
    
    @store = GitStore.new(path)
    @store.handler['md'] = PageHandler.new
    @store.load
  end

  def pages
    store.values.sort_by { |page| page.title }
  end
  
  def call(env)
    store.load if store.changed?
    super
  end

  def transaction(message, &block)
    store.transaction(message, &block)
  end

  def find_page(name)
    store[name + '.md'] or Page.new(:title => name)
  end

  def save_page(name, attr)
    page = find_page(name)
    page.set(attr)
    
    transaction "update `#{page.title}'" do
      store[page.name + '.md'] = page
    end
  end

  def delete_page(page)
    transaction "delete `#{page.title}'" do
      store.delete(page.name + '.md')
    end
  end

  def diff_line_class(line)
    case line[0, 1]
    when '+' then 'added'
    when '-' then 'deleted'
    end
  end

  def page_diffs(name)
    list = []
    
    store.commits(100).each do |commit|
      diffs = commit.diffs("#{name}.md")
      list << [commit, diffs] unless diffs.empty?
    end

    list
  end

  def highlight(html, words)
    tokenizer = HTML::Tokenizer.new(html)
    tokens = []
    
    while token = tokenizer.next
      tokens << token unless token[0, 1] == "<" or token.delete("\r\n\t").empty?
    end

    sections = []
    pattern = /(#{words.join('|')})/i
    i = 0

    while i < tokens.size
      if tokens[i].downcase =~ pattern
        sections << tokens[ [0, i - 5].max .. i + 5].to_a.join(' ')        
        i += 4
      end
      
      i += 1
    end

    sections.map do |section|
      section.gsub(pattern, '<span class="highlight">\1</span>')
    end
  end

  def search(str)
    return [] if str.to_s.empty?
    
    words = str.downcase.split(' ')
    pattern = Regexp.new(words.join('|'))
    matches = []

    pages.each do |page|
      if page.title.downcase =~ pattern
        matches << [page, []]
        
      elsif page.body.downcase =~ pattern
        matches << [page, highlight(page.html, words)]
      end
    end

    matches
  end

end
