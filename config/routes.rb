Rails.application.routes.draw do

  # ----- Members / Users / Login -----

  post   'members/:id/certs'           => 'member_certs#create'
  get    'members/:id/certs'           => 'member_certs#index'
  put    'members/:id/certs/sort'      => 'member_certs#sort'
  get    'members/:id/certs/:cert_id'  => 'member_certs#show'
  post   'members/:id/certs/:cert_id'  => 'member_certs#update'
  delete 'members/:id/certs/:cert_id'  => 'member_certs#destroy'

  resources :sessions
  resources :users

  get    'members'         => 'members#index'
  get    'members/:id'     => 'members#show'
  get    'members/photos'  => 'members#photos'
  get    'members/export'  => 'members#export'
  delete 'members/:id'     => 'members#destroy'

  # ----- Member Data Display -----

  namespace :display do
    resources :cred_log  # history of member credentials
    resources :role_log  # history of role changes
  end

  # ----- Login, Sessions, Passwords -----

  get 'login'  => 'sessions#new',     :as => 'login'
  get 'logout' => 'sessions#destroy', :as => 'logout'

  # user forgot password ...
  get  'password/forgot'       # form that collects an email address
  post 'password/send_email'   # collects an email address and sends email
  get  'password/sending'      # user notice after the email has been sent

  # user forgot password ...
  get  'password/forgot'       # form that collects an email address
  post 'password/send_email'   # collects an email address and sends email
  get  'password/sending'      # user notice after the email has been sent

  # admin resets password ...
  get  'password/forgot_for'      # form that collects an email address
  post 'password/send_email_for'  # collects an email address and sends email
  get  'password/sending_for'     # admin notice after the email has been sent

  get  'password/reset'        # link embedded in the email goes to this page

  # ----- Events -----

  put 'events/:id/periods/sort' => 'event_periods#sort'

  resources :events do
    resources :event_periods, path: 'periods'
  end

  resources :event_reports

  # ----- Paging -----

  get  '/paging'                 => 'pgr/assignments#index'
  get  '/paging/new'             => 'pgr/assignments#new'
  post '/paging'                 => 'pgr/assignments#create'
  get  '/paging/:b_id'           => 'pgr/dialogs#index'       # show page
  post '/paging/:a_sid'          => 'pgr/dialogs#create'      # create followup
  get  '/paging/:b_id/for/:d_id' => 'pgr/posts#index'
  post '/paging/:b_id/for/:d_id' => 'pgr/posts#create'

  get '/pixel/:d_id/for/:m_id'   => 'pgr/posts#pixel'

  # ----- Inbound Mail and SMS -----

  if Rails.env.development? || Rails.env.test?
    post '/inbound/email/letter_opener' => 'inbound/email/letter_opener#create'
    post 'letter_opener_reply'          => 'inbound/email/letter_opener#create'
    post 'sms_opener_reply'             => 'inbound/sms/sms_opener#create'
  end

  post '/inbound/email/mailgun'  => 'inbound/email/mailgun#create'  # create a new inbound email
  post '/inbound/email/mandrill' => 'inbound/email/mandrill#create' # create a new inbound email
  get  '/inbound/email/mandrill' => 'inbound/email/mandrill#show'   # mandrill test/returns 200
  get  '/inbound/sms/nexmo'      => 'inbound/sms/nexmo#create'    # create a new inbound SMS
  get  '/inbound/sms/plivo'      => 'inbound/sms/plivo#create'    # create a new inbound SMS

  # ----- Email Actions -----

  get '/action/rsvp/:outbound_id/:response' => 'action/rsvp#index'  # handle an inbound rsvp action

  # ----- Quals / Cert -----

  get 'certs'                              => 'certs#index'

  get    'quals'                           => 'quals#index'
  get    'quals/:id/certs'                 => 'qual_certs#index'
  get    'quals/:id/certs/sort'            => 'qual_certs#sort'
  get    'quals/:id/certs/:member_id'      => 'qual_certs#show'
  delete 'quals/:id/certs/:mcert_id'       => 'qual_certs#destroy'

  # ----- Availability / Positions -----

  namespace :avail do
    resources :days  #, controller: "avail#days"
    resources :weeks #, controller: "avail#weeks"
  end

  resources :positions

  # ----- Reports -----

  get 'reports'         => 'reports#index'
  get 'creports/:title' => 'reports#show_current_report'
  get 'hreports/:title' => 'reports#show_historical_report'
  get 'reps/:id'        => 'reps#show'

  # ----- Team Admin -----

  get '/admin' => 'admin#index'
  get '/admin/member_ranks/list'  => 'admin/member_ranks#list'
  get '/admin/member_roles/list'  => 'admin/member_roles#list'

  namespace :admin do
    resources :member_ranks
    resources :member_roles
    resources :member_attributes
    resources :member_registry
    resources :member_onboarding
    resource  :team_names
    resource  :team_icon
    resource  :team_features
    resource  :team_navs
    resources :team_owners
    resources :team_partners
    resources :team_certs
    resources :data_import
    resources :event_types
    resources :event_roles
    resources :event_attributes
    resources :position_index
    resources :position_params    # transition day/time
    resources :position_partners
    resources :cert_groups
    resources :cert_defs
    resources :quals
    resources :qual_ctypes
    resources :qual_assignments
    resources :qual_partners
  end

  post   '/admin/svc_index/sort'                => 'admin/svc_index#sort'
  post   '/admin/svc_reps/sort'                 => 'admin/svc_reps#sort'
  post   '/admin/service_reps/sort'              => 'admin/service_reps#sort'
  post   '/admin/service_types/sort'             => 'admin/service_types#sort'
  post   '/admin/service_index/sort'             => 'admin/service_index#sort'
  post   '/admin/service_list/sort'              => 'admin/service_list#sort'
  post   '/admin/service_partners/sort'          => 'admin/service_partners#sort'
  post   '/admin/position_index/sort'            => 'admin/position_index#sort'
  post   '/admin/position_partners/sort'         => 'admin/position_partners#sort'
  post   '/admin/forum_index/sort'               => 'admin/forum_index#sort'
  post   '/admin/drive_index/sort'               => 'admin/drive_index#sort'
  post   '/admin/wiki_index/sort'                => 'admin/wiki_index#sort'
  post   '/admin/qual_ctypes/sort'               => 'admin/qual_ctypes#sort'
  post   '/admin/quals/sort'                     => 'admin/quals#sort'

  post   '/admin/event_types/sort'               => 'admin/event_types#sort'
  post   '/admin/event_types/:id'                => 'admin/event_types#update'

  post   '/admin/event_roles/sort'               => 'admin/event_roles#sort'
  post   '/admin/event_roles/:id'                => 'admin/event_roles#update'

  post   '/admin/event_attributes/sort'          => 'admin/event_attributes#sort'
  post   '/admin/event_attributes/:id'           => 'admin/event_attributes#update'

  post   '/admin/member_attributes/sort'         => 'admin/member_attributes#sort'
  post   '/admin/member_attributes/:id'          => 'admin/member_attributes#update'

  get    '/admin/member_add'                     => 'admin/member_add#new'
  post   '/admin/member_add'                     => 'admin/member_add#create'

  get    '/admin/member_drop'                    => 'admin/member_drop#index'
  post   '/admin/member_drop/:id'                => 'admin/member_drop#update'
  delete '/admin/member_drop/:id'                => 'admin/member_drop#destroy'

  post   '/admin/member_registry/role_one/:id'   => 'admin/member_registry#role_one'
  post   '/admin/member_registry/role_many/:id'  => 'admin/member_registry#role_many'
  post   '/admin/member_registry/:id'            => 'admin/member_registry#update'

  post   '/admin/member_ranks/sort'              => 'admin/member_ranks#sort'
  post   '/admin/member_ranks/:id'               => 'admin/member_ranks#update'
  post   '/admin/member_roles/sort'              => 'admin/member_roles#sort'
  post   '/admin/member_roles/:id'               => 'admin/member_roles#update'

  post   '/admin/team_navs/sort'                 => 'admin/team_navs#sort'
  get    '/admin/team_navs/typelist'             => 'admin/team_navs#typelist'
  post   '/admin/team_navs/:id'                  => 'admin/team_navs#update'
  delete '/admin/team_navs/:id'                  => 'admin/team_navs#destroy'

  get '/nav/header' => 'nav#header'
  get '/nav/footer' => 'nav#footer'
  get '/nav/admin'  => 'nav#admin'

  # ----- Org Admin -----

  namespace :org do
    resources :teams do
      resources :members
      resources :team_features
    end
  end

  # ----- Ajax -----

  get  '/ajax/events/tag_uniq'                           => 'ajax/events#tag_uniq'
  post '/ajax/memberships/:membership_id/phones/sort'    => 'ajax/mems/phones#sort'
  post '/ajax/memberships/:membership_id/emails/sort'    => 'ajax/mems/emails#sort'
  post '/ajax/memberships/:membership_id/addresses/sort' => 'ajax/mems/addresses#sort'
  post '/ajax/memberships/:membership_id/contacts/sort'  => 'ajax/mems/contacts#sort'
  post '/ajax/memberships/:membership_id/certs/sort'     => 'ajax/mems/certs#sort'
  put  '/ajax/avail_day'                                 => 'avail/day#update'

  namespace :ajax do
    resources :topic_status
    resources :members
    resources :action_op_rsvp
    resources :qual_ctypes_attendance
    resources :qual_attendance
    resources :events do
      resource  :event_parent
      resources :event_children
      resources :event_periods
    end
    resources :banned_emails
    resources :event_periods do
      resources :event_participants
    end
    resources :memberships do
      scope :module => :mems do
        resource  :user
        resource  :user_avatar
        resources :phones
        resources :emails
        resources :addresses
        resources :contacts
        resources :others
        resources :forum_subscriptions
        resources :topic_subscriptions
        resources :certs
        resources :qual_certs
      end
    end
    resources :service_resrc_providers
    resources :position_bookings
  end

  # ----- ActionCable -----
  mount ActionCable.server => "/cable"

  # ----- Sidekiq -----
  require 'sidekiq/web'
  Sidekiq::Web.use Rack::Auth::Basic do |user, pass|
    user == 'side' && pass == 'kiq'
  end
  mount Sidekiq::Web => '/sq'

  # ----- Dalli (Sidekiq UI)-----
  mount Dalli::Ui::Engine, at: 'dalli'

  # ----- Published -----
  namespace :published do
    resources :events         , only: [:index, :show]
    resources :team_directory , only: [:index, :show]
  end

  # ----- Js Raw Test -----
  get 'ytst' => 'ytst#index'

  # ----- Test Pages -----

  zcst_pgs = %w(index icons react0 become_do temp_do initiate_callout wip)
  info_pgs = %w(not_authorized domain_not_found page_not_found inactive no_access no_feature not_member)
  ZCST_PAGES = zcst_pgs    unless defined?(ZCST_PAGES)
  HOME_PAGES = %w(index)   unless defined?(HOME_PAGES)
  INFO_PAGES = info_pgs    unless defined?(INFO_PAGES)

  def get_pages(page_list, controller)
    page_list.each do |page|
      get "/#{controller}/#{page}" => "#{controller}##{page}"
    end
  end

  get 'zcst' => 'zcst#index'
  get_pages ZCST_PAGES, 'zcst'
  get_pages HOME_PAGES, 'home'
  get_pages INFO_PAGES, 'info'

  get 'zcst/handle/:template' => 'zcst#handle'

  ztst_pgs = %w(index icons react0 react1 react2 react3 react4 react5 chat pack1 pack2 share1 share2)
  info_pgs = %w(not_authorized domain_not_found page_not_found inactive no_access no_feature not_member)
  ZTST_PAGES = ztst_pgs    unless defined?(ZTST_PAGES)
  HOME_PAGES = %w(index)   unless defined?(HOME_PAGES)
  INFO_PAGES = info_pgs    unless defined?(INFO_PAGES)

  def get_pages(page_list, controller)
    page_list.each do |page|
      get "/#{controller}/#{page}" => "#{controller}##{page}"
    end
  end

  get 'ztst' => 'ztst#index'
  get_pages ZTST_PAGES, 'ztst'
  get_pages HOME_PAGES, 'home'
  get_pages INFO_PAGES, 'info'

  get 'ztst/handle/:template' => 'ztst#handle'

  # ----- Grape API and Swagger Documentation -----

  mount Api::Base                 => '/api'
  mount GrapeSwaggerRails::Engine => '/apidoc'

  # ----- Home -----

  resources :home
  post       '/home/:id/sort'  => 'home#sort'   # for sorting widgets...

  root :to => 'home#index'

  get '*anything' => 'info#page_not_found' unless Rails.env.development?

end
