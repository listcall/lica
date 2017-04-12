class Admin::QualsController < ApplicationController

before_action :authenticate_owner!

  def index
    @title = 'Qualifications'
    @quals = ActiveType.cast(current_team.quals, QualDecorator)
  end

  def create
    qual  = Qual.new params[:cert].permit(:acronym, :name)
    qual.team_id = current_team.id
    qual.position = 0
    if qual.valid? && qual.save
      redirect_to '/admin/quals', notice: "Added #{qual.name}"
    else
      redirect_to '/admin/quals', alert: 'There was a problem...'
    end
  end

def update
  name, value, cid = [params[:name], params[:value], params[:id]]
  qual  = current_team.quals.find(cid)
  qual.send("#{name}=", value)
  qual.update_attribute(name.to_sym, value)
  instrument 'qual.update', {qual_id: qual.id, name: name, value: value}
  render plain: 'OK', layout: false
end

  def destroy
    type = Qual.find params['id']
    type.try(:destroy)
    redirect_to '/admin/quals'
  end

  def sort
    quals = current_team.quals.to_a
    cert_hash  = quals.reduce({}) {|acc, val| acc[val.acronym] = val; acc}
    params['qual'].each_with_index do |key, idx|
      cert_hash[key].update_attribute(:position, idx + 1)
    end
    render plain: 'OK', layout: false
  end
end
