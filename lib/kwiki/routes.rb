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

  history '/history/(.*)' do |name|
    render 'history.rhtml', :page => find_page(name), :diffs => page_diffs(name)
  end

  search '/search' do
    render 'search.rhtml', :matches => search(params['q'])
  end

  edit '/edit/(.*)' do |name|
    get do
      render 'edit.rhtml', :page => find_page(name)
    end

    post do
      if params['title'].empty?        
        render 'edit.rhtml', :message => 'Title is required!', :page => find_page(name)
      else
        save_page(name, params)
        redirect '/' + name
      end
    end
  end

  page '/(.*)' do |name|
    render 'page.rhtml', :page => find_page(name)
  end
end
