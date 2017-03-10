require [Rails.root.to_s, '/lib/ext/string'].join

# Public: Various methods for retrieving users fom the database.
#
class UserFinderSvc

  # Public: Find a user by email, username or userid. The username
  # is typically the label used on the login form field.
  #
  # identifier: an email address, username or userid
  #
  # Returns a single User or nil if there is no match.
  #
  def self.by_username(identifier)
    return User.find(identifier) if identifier.is_a?(Integer)
    case identifier.identification_type
      when 'userid'   then User.find(identifier)
      when 'username' then User.where('user_name ILIKE ?', identifier.username_normalize).to_a.first
      when 'email'    then User.by_email_adr(identifier)
      else nil
    end
  end

end