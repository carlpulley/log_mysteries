Answer::Application.routes.draw do
  match 'report/by' => "report#index", :chapter => "by"
  
  match 'report/web_server/rss/:subsection' => "report#index", :chapter => "web_server", :section => "rss", :subsection => /\d+\.\d+\.\d+\.\d+/
  
  match 'report(/:chapter(/:section(/:subsection)))' => "report#index"
  
  root :to => "report#index"
end
