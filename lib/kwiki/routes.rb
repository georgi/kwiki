KWiki.map do
  
  index '/$' do
    render 'index.rhtml', :pages => pages, :commits => store.commits
  end

  assets '/assets/(.*)' do |asset|
    text File.read(path + '/assets/' + asset)
  end

  commits '/commits/(.*)' do |id|
    render 'commit.rhtml', :commit => store.get(id)
  end

  history '/history/(.*)' do |title|
    render 'history.rhtml', :page => find_page(title), :diffs => page_diffs(title)
  end

  search '/search' do
    render 'search.rhtml', :matches => search(params['q'])
  end

  edit '/edit/(.*)' do |title|
    get do
      render 'edit.rhtml', :page => find_page(title)
    end

    post do
      if params['title'].empty?        
        render 'edit.rhtml', :message => 'Title is required!', :page => find_page(title)
      else
        save_page(title, params)
        redirect '/' + title
      end
    end
  end

  page '/(.*)' do |title|
    render 'page.rhtml', :page => find_page(title)
  end
  
end
