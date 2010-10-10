Answer::Application.routes.draw do
  match 'report/by', :controller => "report", :action => :index, :chapter => "by"
  
  match 'report/web_server/rss/:subsection', :controller => "report", :action => :index, :chapter => "web_server", :section => "rss", :constraints => { :subsection => /\d+\.\d+\.\d+\.\d+/ }
  
  match 'report(/:chapter(/:section(/:subsection)))', :controller => "report", :action => :index
end
