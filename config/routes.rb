Answer::Application.routes.draw do
  match 'research/by' => "research#index", :chapter => "by"
  
  match 'research/web_server/rss/:subsection' => "research#index", :chapter => "web_server", :section => "rss", :subsection => /\d+\.\d+\.\d+\.\d+/
  
  match ':controller(/:chapter(/:section(/:subsection)))' => '#index'
  
  root :to => "report#index"
end
