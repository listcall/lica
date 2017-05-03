module Api
  class Base < Grape::API
    default_format :json

    helpers do
      def session
        @session ||= ENV['rack.session'].to_hash
      end

      def domain
        @domain ||= ENV['HTTP_HOST'].split('.').first
      end

      def current_team
        return nil if domain.blank?
        @current_team ||= Team.where('acronym ILIKE ?', domain).to_a.first
      end

      def current_user
        @current_user ||= User.find(session['user_id']) if session['user_id']
      end

      def current_membership
        return nil unless current_team && current_user
        @current_membership ||= Membership.find_by(user_id: current_user.id, team_id: current_team.id)
      end

      def authenticate!
        return if params[:token] && params[:token] == 'Utpw4SUs'
        error!('401 Unauthorized', 401) unless current_membership
      end

      def event_data(ev)
        {
          title: ev.title,
          type:  ev.typ_name,
          start: ev.start.strftime('%a %b-%d'),
          ref:   ev.event_ref
        }
      end
    end

    before do
      authenticate!
    end

    resource :util do
      desc 'Authorize username/password'
      params do
        requires :usr, type: String, desc: 'Username or Email address'
        requires :pwd, type: String, desc: 'Password'
      end
      get :auth do
        user = UserFinderSvc.by_username(params[:usr])
        mems = current_team.memberships
        valid_usr = user && user.authenticate(params[:pwd])
        valid_mem = valid_usr && mems.find_by(user_id: user.id)
        valid_mem ? 'OK' : 'FAIL'
      end
    end

    resource :test do
      desc 'Hello world string'
      get :hello do
        'Hello World'
      end

      desc 'Return current time'
      get :time_now do
        Time.now
      end
    end

    resource :widget do
      desc 'Basic hello world object'
      get :hello do
        {hello: 'world'}
      end

      desc 'Membership Statistics'
      get :member_stats do
        {
          title: 'Membership Statistics',
          team_acronym:  current_team.acronym,
          active_count:  current_team.members.active.count,
          reserve_count: current_team.members.reserve.count,
          guest_count:   current_team.members.guest.count,
        }
      end

      desc 'About Info'
      get :about do
        { title: 'About' }
      end

      desc 'Extended hello world object'
      get :handle do
        {
          title: 'Hello world extended title',
          body: 'Hello World extended body',
          lst:  [{name: 'x'}, {name: 'y'}],
          tbl:  [[{org: 'a'}, {city: 'b'}],[{org: 'c'}, {city: 'd'}]],
        }
      end

      desc 'Session data'
      get :session_data do
        {
          title: 'Session Data',
          user_name: current_user.user_name,
          first_name: current_user.first_name,
          last_name:  current_user.last_name,
          user_id:    current_user.id,
          team_id:      current_team.id,
          team_name:    current_team.name,
          team_acronym: current_team.acronym,
          member_rank:   current_membership.rank,
          member_roles:  current_membership.roles,
          member_rights: current_membership.rights,
        }
      end

      desc 'Upcoming Event Summary'
      get :upcoming_events do
        {
          title:           'Upcoming Events',
          current_count:   current_team.events.current.count,
          upcoming_count:  current_team.events.upcoming.count,
          upcoming_start:  (Time.now + 1.day).strftime('%b-%d'),
          upcoming_finish: Event.upcoming_finish.strftime('%b-%d'),
          current_events:  current_team.events.current.map {|ev| event_data(ev)},
          upcoming_events: current_team.events.upcoming.map {|ev| event_data(ev)}
        }
      end
    end

    add_swagger_documentation(
      base_path: '/api',
      hide_documentation_path: true
    )
  end
end
