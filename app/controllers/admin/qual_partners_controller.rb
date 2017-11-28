class Admin::QualPartnersController < ApplicationController

before_action :authenticate_member!

  def index
    @title  = 'Cert Dashqual Partnerships'
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
    quals = current_team.qual_partners
    quals.destroy params['id']
    current_team.qual_partners = quals
    current_team.save
    redirect_to '/admin/qual_partnerss'
  end

  def sort
    qual_partners = current_team.qual_partners.to_a
    cert_hash  = qual_partners.reduce({}) {|acc, val| acc[val.acronym] = val; acc}
    params['qual'].each_with_index do |key, idx|
      cert_hash[key].update_attribute(:position, idx + 1)
    end
    render plain: 'OK', layout: false
  end

end
