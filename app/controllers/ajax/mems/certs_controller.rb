class Ajax::Mems::CertsController < ApplicationController

  before_action :authenticate_member!

  respond_to :json, :html
  layout false

  def new
    @ctype_id = params['qual_ctype_id']
    @ctype    = QualCtype.find(@ctype_id)
    @member   = current_team.memberships.by_id_or_user_name(params[:membership_id]).first
    @cert     = MemCertForm.new(membership_id: @member.id, qual_ctype_id: params['qual_ctype_id'])
  end

  def edit
    @member   = current_team.memberships.by_id_or_user_name(params[:membership_id]).first
    @cert     = MemCertForm.new(id: params['id'])
    @ctype_id = @cert.qual_ctype_id
    @ctype    = QualCtype.find(@ctype_id)
  end

  def create
    @member = current_team.memberships.by_id_or_user_name(params[:membership_id]).first
    opts = params['mem_cert_form']
    opts['title'] = params['new_title'] unless params['new_title'].blank?
    @cert   = MemCertForm.new(params['mem_cert_form'])
    if @cert.valid? && @cert.generate
      render plain: 'OK'    # JS will re-load the page...
    else
      @ctype_id = @cert.qual_ctype_id
      @ctype    = QualCtype.find(@ctype_id)
      render :new, status: 400
    end
  end

  def update
    opts = {'id' => params['id']}.merge(params['mem_cert_form'].to_unsafe_h)
    opts['title'] = params['new_title'] unless params['new_title'].blank?
    @cert = MemCertForm.new(opts)
    if @cert.valid? && @cert.update
      render plain: 'OK'
    else
      @member = current_team.memberships.by_id_or_user_name(params[:membership_id]).first
      @ctype_id = @cert.qual_ctype_id
      @ctype    = QualCtype.find(@ctype_id)
      render :edit, status: 400
    end
  end

  def sort
    params['certSort'].each_with_index do |mcert_id, idx|
      MembershipCert.find(mcert_id).update_attributes(position: idx+1)
    end
    render plain: 'OK', layout: false
  end
end
