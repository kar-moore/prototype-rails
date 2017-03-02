Rails.application.routes.draw do
  get '/feed', controller: 'frontend_rss', action: 'feed', as: 'frontend_rss_feed', defaults: {format: 'rss'}

  get '/:section_name/:id(/:slug)', controller: 'frontend_pieces', action: 'show_old_url', constraints: {id: /\d+/, section_name: /(news|world-and-nation|opinion|arts|sports|campus-life|fun)/}

  get '/:year/:month/:day/:slug', controller: 'frontend_pieces', action: 'show_before_redirect', as: 'frontend_piece', constraints: {year: /\d{4}/, month: /\d{2}/, day: /\d{2}/}
  get '/authors/:id(/:page)', controller: 'frontend_authors', action: 'show', as: 'frontend_author'
  get '/photographers/:id(/:page)', controller: 'frontend_photographers', action: 'show', as: 'frontend_photographer'
  get '/tags/:id(/:page)', controller: 'frontend_tags', action: 'show', as: 'frontend_tag'
  get '/:id(/page/:page)', controller: 'frontend_sections', action: 'show', as: 'frontend_section', constraints: {id: /(news|world-and-nation|opinion|arts|sports|campus-life|fun)/}
  get '/search(/:query)(/page/:page)', controller: 'frontend_pieces', action: 'search', as: 'frontend_search', constraints: {query: /.*?(?=\/)*/}
  get '/image_search(/:query)(/page/:page)', controller: 'frontend_pieces', action: 'image_search', as: 'frontend_image_search', constraints: {query: /.*?(?=\/)*/}
  get '/issues', controller: 'frontend_issues', action: 'index', as: 'frontend_issue_index'
  get '/issues/(:volume)/(:number)', controller: 'frontend_issues', action: 'show', as: 'frontend_issue', constraints: {volume: /\d+/, number: /\d+/}

  get '/:volume/:number/:archivetag', controller: 'legacy_redirect', action: 'show_piece', constraints: {volume: /V\d+/, number: /N\d+/, archivetag: /[^\/]*\.html/}
  get '/:volume/:number/:parent/:archivetag', controller: 'legacy_redirect', action: 'show_piece', constraints: {volume: /V\d+/, number: /N\d+/, parent: /.*/, archivetag: /.*\.html/}

  get '/niceties/:id', controller: 'frontend_ads', action: 'relay', constraints: {id: /\d+/}, as: 'ads_relay'

  namespace :api do
    get 'issue_lookup/:volume/:issue', action: 'issue_lookup'
    get 'article_as_xml/:id', action: 'article_as_xml'
    get 'newest_issue'
    get 'article_parts'
    get 'style_mapping'
  end

  scope '/admin' do
    if ENV['MAINTENANCE'].present?
      match '*path', via: [:get, :post, :patch, :delete, :put], to: 'static_pages#maintenance'
      match '/', via: [:get, :post, :patch, :delete, :put], to: 'static_pages#maintenance'
    end

    get '/', to: 'static_pages#admin_homepage', as: :admin_root

    resources :ads

    resources :article_lists, only: [:new, :create, :edit, :update, :index, :destroy, :show] do
      member do
        post 'append_item'
        post 'remove_item'
      end
    end

    resources :homepages, only: [:index, :show, :update] do
      member do
        post 'mark_publish_ready'
        post 'duplicate'
        post 'publish'
      end

      collection do
        get 'new_submodule_form'
        get 'new_row_form'
        post 'new_specific_submodule_form'
        post 'create_specific_submodule'
        post 'create_new_row'
      end
    end

    resources :issues, only: [:index, :show, :create] do
      member do
        get 'upload_pdf_form'
        post 'upload_pdf'
        delete 'remove_pdf'
      end
    end

    resources :authors

    resources :sections

    resources :series

    resources :pieces

    resources :images do
      resources :pictures, only: [:create, :destroy] do
        member do
          get 'direct'
        end
      end

      member do
        # I seriously doubt whether 'unassign' is a proper English word. But whatever..
        post 'unassign_piece'
        post 'assign_piece'
        post 'publish'
      end
    end

    resources :articles, only: [:index, :new, :create, :edit, :update, :destroy] do
      resources :article_versions, only: [:index, :show] do
        member do
          get 'revert'
          post 'publish'
          patch 'update_web_status'
          post 'mark_print_ready'
          get 'below_fold_preview'
        end
      end

      member do
        get 'assets_list'
        patch 'update_rank'
      end

      collection do
        get 'below_fold_preview', controller: 'article_versions', action: 'below_fold_preview'
      end
    end

    devise_for :users, controllers: {
      registrations: 'users/registrations'
    }
    resources :users, only: [:index, :show, :edit, :update]

    get '/publish', controller: 'publishing', action: 'dashboard', as: 'publishing_dashboard'
    post '/publish', controller: 'publishing', action: 'publish'
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'frontend_homepage#show'
  get 'weather-info', controller: 'frontend_homepage', action: 'weather'
  get 'niceties-manifest', controller: 'frontend_ads', action: 'ads_manifest', as: 'ads_manifest'

  get '/ads/adinfo', controller: 'frontend_static_pages', action: 'adinfo'
  get '/:name', controller: 'frontend_static_pages', action: 'show', as: 'frontend_static_page', constraints: {name: /(ads(\/(index|schedule|policies|payment|adscontact))?)|(about(\/(index|contact|opinion_policy|comments|unpublish|copyright|publication_schedule|subscribe|special_projects|donate|join|staff))?)/}
  get '/ads/adinfo/:advertiser_type', controller: 'frontend_static_pages', action: 'adinfo',
    as: 'frontend_adinfo', constraints: {advertiser_type: /[^.]*/}
  # get '/:name', controller: 'frontend_static_pages', action: 'show', as: 'frontend_static_page', constraints: {name: /[^.]*/}


  #Sitemap routes
  # get '/google_search_sitemap.xml.gz', as: :sitemap
  # get '/google_news_sitemap.xml.gz', as: :sitemap

  post '/update_mast', controller: 'frontend_static_pages', action: 'update_mast'
    # match '/testing' => 'frontend_static_pages#update_mast', via: :post

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
