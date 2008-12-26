Kontrol.map do
  get '/$' do
    render 'home.rhtml', :pages => pages.sort_by { |p| p.name }
  end

  get '/assets/stylesheets\.css' do
    render_stylesheets
  end

  get '/assets/(.*)' do |path|
    if_modified_since do
      assets[path] or raise "#{path} not found"
    end
  end  
  
  get '/commits/(.*)' do |id|    
    render 'commit.rhtml', :commit => repo.commit(id)
  end

  get '/commits' do
    render 'commits.rhtml', :commits => repo.commits
  end

  get '/(.*)/edit' do |name|
    render 'edit.rhtml', :page => pages[name + '.md'] || KWiki::Page.new(name, "")
  end

  post '/(.*)' do |name|
    page = pages[name + '.md'] ||= KWiki::Page.new(name, "")
    page.body = params['data']
    store.commit "updated `#{name}`"
    redirect name
  end
  
  get '/(.*)' do |name|
    if page = pages[name + '.md']
      render 'page.rhtml', :page => page
    else
      redirect "/#{name}/edit"
    end
  end
end
