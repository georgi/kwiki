KWiki - Git-based Wiki Engine
=============================

KWiki is a small [Wiki][1] engine using [Git][2] as backend. KWiki
runs on [Rack][3] via the micro framework [Kontrol][4] and uses
[GitStore][5] for easy repository accesss.

### Features

* Pages are simple text files with a [YAML][6] Header and
  [Markdown][7] formatting

* Customizable [RHTML][8] templates

* WMD Markdown Editor for page editing

* Viewable commit pages with diffs

* Viewable history with diffs for a single page

* Full text search with highlighted results


### Quickstart

Install the gems:

    $ gem sources -a http://gems.github.com
    $ gem install rack BlueCloth georgi-git_store georgi-kontrol georgi-kwiki

Create a repository:

    $ mkdir wiki
    $ cd wiki
    $ git init

Start server:

    $ kwiki .

Browse to:

    http://localhost:3000

Now just enter a page title into the location bar to create a new page:

    http://localhost:3000/My_First_Page

Note, that underscores will be replaced with spaces. So urls have
underscores, but the corresponding page titles have not.
