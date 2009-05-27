class KWiki < Kontrol::Application

  DIR = File.expand_path(File.dirname(__FILE__) + '../../..')

  attr_reader :store, :pages

  # Initialize a Wiki with path to git repository
  def initialize(path)
    super(DIR)
    
    @store = GitStore.new(path)
    @store.handler['md'] = PageHandler.new
    @store.load
  end

  # Return all wiki pages as array sorted by title
  def pages
    store.values.sort_by { |page| page.title }
  end

  # Rack interface
  def call(env)
    store.load if store.changed?
    super
  end

  # Shortcut for GitStore transaction
  def transaction(message, &block)
    store.transaction(message, &block)
  end

  # Replace underscores with spaces
  def normalize_title(title)
    title.gsub(/_/, ' ')
  end

  # Find page by title
  def find_page(title)
    title = normalize_title(title)
    
    store[title + '.md'] or Page.new(:title => title)
  end

  # Create or update a page with specified title
  def save_page(title, attr)
    title = normalize_title(title)
    
    page = find_page(title)
    page.set(attr)
    
    transaction "update `#{page.title}'" do
      store[page.title + '.md'] = page
    end
  end

  # Remove a page from the store
  def delete_page(page)
    transaction "delete `#{page.title}'" do
      store.delete(page.title + '.md')
    end
  end

  # Return the css class for a diff line
  def diff_line_class(line)
    case line[0, 1]
    when '+' then 'added'
    when '-' then 'deleted'
    end
  end

  # Return diffs of a single page as pairs of [commit, diff]
  def page_diffs(title)
    title = normalize_title(title)
    list = []
    
    store.commits(100).each do |commit|
      diffs = commit.diffs("#{title}.md")
      list << [commit, diffs] unless diffs.empty?
    end

    list
  end

  # Highlight given words in a section of html
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

  # Search string in all pages and return pairs of [page, highlighted_match]
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
