class MemberCertsSvc

  def initialize(membership)
    @membership = membership
  end

  def list
    mem_certs = @membership.membership_certs.sorted.to_a
    mcert_ids = mem_certs.map {|x| x.user_cert_id}
    ucert_ids = @membership.user_certs.pluck(:id)
    ucert_ids.each do |ucert_id|
      unless mcert_ids.include?(ucert_id)
        mem_certs << MembershipCert.create(user_cert_id: ucert_id, membership_id: @membership.id, typ: 'Other')
      end
    end
    mem_certs
  end

end