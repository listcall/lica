# new_serv

class Admin::PositionPartnersController < ApplicationController

before_action :authenticate_member!

  def index
    @pos_partners = current_team.position_partners.sorted
    # @title  = "Position Partnerships"
  end

  def create
    quals = current_team.qual_partners
    qual  = Qual.new params[:cert]
    quals.add_obj(qual)
    current_team.qual_partners = quals
    if current_team.valid?
      current_team.save
      redirect_to '/admin/qual_partners', notice: "Added #{qual.name}"
    else
      redirect_to '/admin/qual_partners', alert: 'There was a problem...'
    end
  end

def update
  name, value, cid = [params[:name], params[:value], params[:id]]
  qual  = current_team.qual_partners.find(cid)
  qual.send("#{name}=", value)
  qual.update_attribute(name.to_sym, value)
  render plain: 'OK', layout: false
end

  def destroy
    position_partnership = current_team.position_partners.find(params['id'])
    position_partnership.try(:destroy)
    redirect_to '/admin/position_partners'
  end

  def sort
    position_partners = current_team.position_partners.to_a
    pos_hash = position_partners.reduce({}) {|acc, val| acc[val.id] = val; acc}
    params['partner'].each_with_index do |key, idx|
      pos_hash[key.to_i].update_attribute(:sort_key, idx + 1)
    end
    render plain: 'OK', layout: false
  end

end
