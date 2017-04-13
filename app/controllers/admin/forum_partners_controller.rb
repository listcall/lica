class Admin::ForumPartnersController < ApplicationController

before_action :authenticate_owner!

  def index
    @title  = 'Forum Partnerships'
  end

  def create
    boards = current_team.forum_partners
    board  = Forum.new params[:cert]
    boards.add_obj(board)
    current_team.forum_partners = boards
    if current_team.valid?
      current_team.save
      redirect_to '/admin/forum_partners', notice: "Added #{board.name}"
    else
      redirect_to '/admin/forum_partners', alert: 'There was a problem...'
    end
  end

def update
  name, value, cid = [params[:name], params[:value], params[:id]]
  board  = current_team.forum_partners.find(cid)
  board.send("#{name}=", value)
  board.update_attribute(name.to_sym, value)
  render plain: 'OK', layout: false
end

  def destroy
    boards = current_team.forum_partners
    boards.destroy params['id']
    current_team.forum_partners = boards
    current_team.save
    redirect_to '/admin/forum_partnerss'
  end

  def sort
    forum_partners = current_team.forum_partners.to_a
    cert_hash  = forum_partners.reduce({}) {|acc, val| acc[val.acronym] = val; acc}
    params['board'].each_with_index do |key, idx|
      cert_hash[key].update_attribute(:position, idx + 1)
    end
    render plain: 'OK', layout: false
  end

end
