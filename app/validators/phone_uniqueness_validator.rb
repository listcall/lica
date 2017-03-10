class PhoneUniquenessValidator < ActiveModel::Validator
  def validate(record)
    relation = User::Phone.where(number: record.number)
    return if relation.count == 0
    records  = relation.to_a.select {|x| x.id != record.id}
    return if records.count == 0
    return if record.typ == "Home" && records.all? do |obj|
      obj.typ == "Home" && obj.user_id != record.user_id
    end
    if records.any? {|obj| obj.user_id == record.user_id }
      msg = record.user ? " for #{record.user.user_name}" : ""
      record.errors[:duplicate] << "number#{msg}"
    else
      record.errors[:duplicate] << "number (#{record.number})"
    end
  end
end