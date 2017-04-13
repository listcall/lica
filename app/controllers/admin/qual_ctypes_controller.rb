class Admin::QualCtypesController < ApplicationController

before_action :authenticate_owner!

  def index
    @title = 'Cert Types'
    @types = current_team.qual_ctypes.to_a
  end

  def create
    type  = QualCtype.new params[:cert].permit(:acronym, :name)
    type.team_id = current_team.id
    type.position = 0
    if type.valid? && type.save
      redirect_to '/admin/qual_ctypes', notice: "Added #{type.name}"
    else
      redirect_to '/admin/qual_ctypes', alert: 'There was a problem...'
    end
  end

def update
  name, value, cid = [params[:name], params[:value], params[:id]]
  type  = current_team.qual_ctypes.find(cid)
  cleanup_memcerts(type, name, value)
  type.send("#{name}=", value)
  type.save
  render plain: 'OK', layout: false
end

  def destroy
    type = QualCtype.find params['id']
    type.try(:destroy)
    redirect_to '/admin/qual_ctypes'
  end

  def sort
    qual_ctypes = current_team.qual_ctypes.to_a
    cert_hash  = qual_ctypes.reduce({}) {|acc, val| acc[val.acronym] = val; acc}
    params['type'].each_with_index do |key, idx|
      cert_hash[key].update_attribute(:position, idx + 1)
    end
    render plain: 'OK', layout: false
  end

  private

  def cleanup_memcerts(type, name, value)
    return unless name == 'ev_types'
    return unless type.ev_types.include?('attendance') && ! value.include?('attendance')
    type.membership_certs.attendance.each {|x| x.destroy}
  end
end
