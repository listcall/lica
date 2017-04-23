class HomeController < ApplicationController

  skip_around_action :scope_current_team
  before_action      :authenticate_reserve!

  def index
    base_dir = "#{Rails.root.to_s}/app/views/home/widgets"
    @member  = current_membership.becomes(Membership::AsHome)
    @col1 = @member.widget_col1.split(' ')
    @col2 = @member.widget_col2.split(' ')
    @tlist = Dir.glob("#{base_dir}/*.hbs").map {|x| File.basename(x, '.hbs')}.sort
    intermed  = @tlist.reduce({}) do |acc, file|
      base = "#{base_dir}/#{file}.hbs"
      acc[file] = CGI::escapeHTML(File.read(base).gsub("\n", ''))
      acc
    end
    @templates = intermed.to_json
  end

  def create
    mem = Membership.find(params['id']).becomes(Membership::AsHome)
    list = mem.widget_col1.split(' ')
    new_list = ([params['type']] + list).join(' ')
    mem.widget_col1 = new_list
    mem.save
    render plain: 'OK'
  end

  def destroy
    col, _type, idx = params.to_unsafe_h['widget'].split('-')
    mem = Membership.find(params['id'])
    base = mem.xfields["widget_#{col}"] || mem.send("default_widget_#{col}")
    list = base.split(' ')
    list.delete_at(idx.to_i - 1)
    mem.xfields["widget_#{col}"] = list.join(' ')
    mem.xfields_will_change!
    mem.save
    render plain: 'OK'
  end

  def sort
    mem = Membership.find(params[:id])
    col = params[:col]
    list = make_list(params['list'])
    mem.xfields["widget_#{col}"] = list
    mem.xfields_will_change!
    mem.save
    render plain: 'OK'
  end

  private

  def make_list(string)
    string.
      gsub(/col[12]\-/, '').
      gsub(/\[\]\=\d+/, '').
      split('&').
      join(' ')
  end
end
