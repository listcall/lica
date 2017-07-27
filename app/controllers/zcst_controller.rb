class ZcstController < ApplicationController

  before_action :authenticate_reserve!

  skip_around_action :scope_current_team

  def index             ;   end
  def icons             ;   end
  def react0            ;   end
  def become_do         ;   end
  def temp_do           ;   end
  def initiate_callout  ;   end
  def wip  ;   end

  def handle
    @col1 = %w(hello handle)
    @col2 = %w(handle hello)
    templates = (@col1 + @col2).uniq.sort
    intermed  = templates.reduce({}) do |acc, file|
      base = "#{Rails.root.to_s}/app/views/ztst/#{file}.hbs"
      acc[file] = CGI::escapeHTML(File.read(base).gsub("\n", ''))
      acc
    end
    @templates = intermed.to_json
  end

  def two
    render plain: 'OK'
  end

  def four
    render plain: 'ERROR', status: 400
  end

  def form1
    @user = User.new
  end

end
