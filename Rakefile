require "rubygems"
require "tmpdir"

require "bundler/setup"
require "jekyll"


# Change your GitHub reponame
GITHUB_REPONAME = "ellerenad/ellerenad.github.io"


desc "Generate blog files"
task :generate do
  Jekyll::Site.new(Jekyll.configuration({
    "source"      => ".",
    "destination" => "_site"
  })).process
end


desc "Generate and publish blog to gh-pages"
task :publish => [:generate] do
    tmp = "../tmp/ellerenad.github.io"
    system "rm -rf #{tmp}"
    system "mkdir -p #{tmp}"

    cp_r "_site/.", tmp

    pwd = Dir.pwd
    Dir.chdir tmp

    system "git init"
    system "git add ."
    system "git config commit.gpgsign false"
    system 'git config user.name "Enrique Llerena Dominguez"'
    system "git config user.email ellerenad@hotmail.com"
    message = "Site updated at #{Time.now.utc}"
    system "git commit -m #{message.inspect}"
    system "git remote add origin https://github.com/ellerenad/ellerenad.github.io"
    system "git push origin master --force"

    Dir.chdir pwd
end
