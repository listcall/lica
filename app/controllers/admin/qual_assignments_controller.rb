class Admin::QualAssignmentsController < ApplicationController

  before_action :authenticate_member!

  def index
    @title  = 'Cert Qual Assignments'
    @types  = current_team.qual_ctypes.to_a
    @quals = current_team.quals.includes(:qual_assignments).to_a
    @assigs = @quals.reduce([]) do |acc, brd|
      acc.concat(brd.qual_assignments)
    end
  end

  def create
    status = params[:state]
    opts   = params.slice(:qual_id, :qual_ctype_id)
    if status == 'unused'
      qual = QualAssignment.where(valid(opts)).to_a.first
      qual.try(:destroy)
    else
      valid_opts = valid(opts)
      qual = QualAssignment.find_by(valid_opts) || QualAssignment.create(valid_opts)
      qual.update_attribute :status, status
    end
    render plain: 'OK', layout: false
  end

  def update
    name, value, cid = [params[:name], params[:value], params[:id]]
    qual  = current_team.quals.find(cid)
    qual.send("#{name}=", value)
    qual.update_attribute(name.to_sym, value)
    render plain: 'OK', layout: false
  end

  def destroy
    quals = current_team.quals
    quals.destroy params['id']
    current_team.quals = quals
    current_team.save
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

  private

  def valid(opts)
    opts.permit(:qual_id, :qual_ctype_id)
  end

end
