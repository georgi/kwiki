require 'kontrol'
require 'rubypants'
require 'bluecloth'

class KWiki < Kontrol::Application

  def pages
    store.root.tree('pages')
  end

  def edit_path(page)
    "/edit/#{page.name}"
  end

  def find_page(name)
    pages[name + '.md'] or Page.new(:name => name)
  end

  def create_page(attr)
    page = Page.new(attr)
    
    transaction "create '#{page.title}'" do
      store[page.path] = page
    end
  end

  def update_page(name, attr)
    page = find_page(name)
    page.parse(data)
    
    transaction "update '#{page.title}'" do
      pages[page.name + '.md'] = page
    end
  end

  def delete_page(page)
    transaction "delete '#{page.title}'" do
      pages.delete(page.name + '.md')
    end
  end

  def diff_line_class(line)
    case line[0, 1]
    when '+' then 'added'
    when '-' then 'deleted'
    end
  end 

end
