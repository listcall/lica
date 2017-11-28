class ReportsController < ApplicationController

  before_action :authenticate_member!

  def index
    @current_report_list    = current_report_list
    @historical_report_list = historical_report_list
  end

  # router regex /creports/:title
  # invoke using /creports/BAMRU-roster.html
  def show_current_report
    @members   = current_team.memberships.active.by_last_name
    @reserves  = current_team.memberships.reserve.by_last_name
    @guests    = current_team.memberships.guests_only.by_last_name
    args = {:layout => nil, :formats => [params[:format]]}
    render "_c_#{params[:title]}", args
  end

  # router regex /hreports/:title
  # invoke using /hreports/MRA.html?start=2011-02&finish=2012-03&member_id=23
  def show_historical_report
    @start   = params[:start]
    @finish  = params[:finish]
    @user_id = params[:user_id]
    @title   = params[:title]
    @type    = params[:type]
    @rsvc    = eval("Report#{@title}Svc").new(current_team, @start, @finish, @type)
    render "_h_#{@title}.#{params[:format]}", {:layout => nil}
  end

  protected

  # report_type, report_name, report_file, report_description
  def current_report_list
    [
      ['Roster',  'CSV Active Export',  'active-roster.csv',          'For import to Excel (Active Members)'],
      ['Roster',  'CSV Reserve Export', 'reserve-roster.csv',         'For import to Excel (Reserve Members)'],
      ['Roster',  'CSV Guest Export',   'guest-roster.csv',           'For import to Excel (Guest Members)'],
      ['Roster',  'CSV Report (SMSO)',  'member-roster-smso.csv',     'CSV formatted for SMSO'],
      ['Roster',  'VCF Report',         'member-roster.vcf',          'VCARD for importing into Gmail & Outlook'],
      ['Roster',  'Member Full',        'member-full.pdf',            'Member roster with full contact info'],
      ['Roster',  'Member Field',       'member-field.pdf',           'One page roster with basic contact info'],
      ['Roster',  'Member Wallet',      'member-wallet.pdf',          'A credit-card sized roster for your wallet'],
      ['Misc',    'Member Names',       'member-names.pdf',           'List of names for ProDeal reporting'],
      ['Misc',    'Member Photos',      'member-photos.html',         'Member Photos'],
      ['Misc',    'Guest Photos',       'guest-photos.html',          'Guest Photos'],
    ]
  end

  # report_name, report_description, show_name_picker
  def historical_report_list
    [
      #["Detail",   "Unit-wide Activity Detail",  false],
      ['Summary',  'Unit-wide Activity Summary (sorted by date)',     'date' ],
      ['Summary',  'Unit-wide Activity Summary (sorted by hours)',    'hours'],
      ['Activity', 'Member Activity Detail'                      ,    'x']
    ]
  end

  def cx_type(format)
    case format.upcase
      when 'XLS'  then 'application/vnd.ms-excel'
      when 'PDF'  then 'application/pdf'
      when 'CSV'  then 'text/csv'
      when 'VCF'  then 'text/plain'
      when 'HTML' then 'text/html'
      else 'text/plain'
    end
  end

  def save_params_to_session(params)
    title = params[:title]   || session[:title]
    format = params[:format] || session[:format]
    session[:title]  = title
    session[:format] = format
    [title, format]
  end

end

