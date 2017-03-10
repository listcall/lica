class TeamAltDomainValidator < ActiveModel::Validator
  def validate(record)
    domain = record.domain
    if Team.where(altdomain: "http://#{domain}").count != 0
      record.errors[:base] << "Domain name (#{domain}) has been taken"
    end
  end
end