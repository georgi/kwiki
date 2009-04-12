KWiki.map do
  get '/$' do
    render 'index.rhtml', :pages => pages.sort_by { |p| p.name }
  end

  get '/assets/(.*)' do |path|
    if file = assets[path]
      if_none_match(etag(file)) { file }
    else
      response.status = 404
    end
  end

  get '/commits/(.*)' do |id|
    render 'commit.rhtml', :commit => repo.commit(id)
  end

  get '/commits' do
    render 'commits.rhtml', :commits => repo.commits
  end

  map '/edit' do
    get '/(.*)' do |name|
      render 'edit.rhtml', :page => find_page(name)
    end

    post '/(.*)' do |name|
      update_page(name, :title => params['title'], :body => params['body'])
      redirect name
    end
  end

  get '/(.*)' do |name|
    if page = pages[name + '.md']
      render 'page.rhtml', :page => page
    else
      redirect "/edit/#{name}"
    end
  end
end
