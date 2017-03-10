class AccountDomainValidator < ActiveModel::Validator
  def validate(record)
    altdomain = record.altdomain
    return if altdomain.blank?
    if Org.where(domain: altdomain.gsub('http://','')).count != 0
      record.errors[:base] << "Alt-domain (#{altdomain}) has already been taken"
    end
  end
end