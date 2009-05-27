Gem::Specification.new do |s|
  s.name = 'kwiki'
  s.version = '0.1.0'
  s.summary = 'Git-based Wiki Engine'
  s.author = 'Matthias Georgi'
  s.email = 'matti.georgi@gmail.com'
  s.homepage = 'http://www.matthias-georgi.de/kwiki'
  s.description = 'Git-based Wiki Engine'
  s.require_path = 'lib'
  s.has_rdoc = true
  s.executables << 'kwiki'
  s.extra_rdoc_files = ['README.md']  
  s.files = %w{
assets/stylesheets/print.css
assets/stylesheets/wiki.css
assets/wmd/images/bg-fill.png
assets/wmd/images/bg.png
assets/wmd/images/blockquote.png
assets/wmd/images/bold.png
assets/wmd/images/code.png
assets/wmd/images/h1.png
assets/wmd/images/hr.png
assets/wmd/images/img.png
assets/wmd/images/italic.png
assets/wmd/images/link.png
assets/wmd/images/ol.png
assets/wmd/images/redo.png
assets/wmd/images/separator.png
assets/wmd/images/ul.png
assets/wmd/images/undo.png
assets/wmd/images/wmd-on.png
assets/wmd/images/wmd.png
assets/wmd/showdown.js
assets/wmd/wmd-base.js
assets/wmd/wmd-plus.js
assets/wmd/wmd.js
bin/kwiki
lib/kwiki.rb
lib/kwiki/kwiki.rb
lib/kwiki/routes.rb
lib/kwiki/page.rb
lib/kwiki/tokenizer.rb
templates/commit.rhtml
templates/edit.rhtml
templates/history.rhtml
templates/index.rhtml
templates/layout.rhtml
templates/page.rhtml
templates/search.rhtml
}
end
