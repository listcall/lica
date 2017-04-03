class ZtstController < ApplicationController

  before_action :authenticate_reserve!

  skip_around_action :scope_current_team

  def index   ;   end

  def icons   ;   end
  def react1  ;   end
  def react2  ;   end
  def react3  ;   end
  def react4  ;   end
  def react5  ;   end
  def react6  ;   end
  def reflux  ;   end
  def ace     ;   end
  def d3      ;   end
  def cjs     ;   end
  def chat    ;   end
  def pack1   ;   end

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
    render text: 'OK'
  end

  def four
    render text: 'ERROR', status: 400
  end

  def form1
    @user = User.new
  end

end
