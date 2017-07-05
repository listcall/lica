require 'csv'

module Import
  class Bamru

    def self.ppp(string = '.')
      print string
      $stdout.flush
    end

    def self.all
      self.members
      self.certs
      self.phones
      self.emails
      self.addresses
      self.others
      puts ' '
    end

    def self.members(path = 'data/seed/bamru/members.csv')
      puts '-- Members'
      team = Team.where(:acronym => 'BAMRU').to_a.first
      CSV.read(path).each do |mem_arr|
        # create user record
        user_opts = {
          first_name: mem_arr[0],
          last_name:  mem_arr[1]
        }
        ppp
        user = User.where(user_opts).to_a.first || FG.create(:user, user_opts)
        unless (avatar_path = mem_arr[4]).nil?
          path = avatar_path.split('?').first
          ifil = "data/seed/bamru#{path}"
          if File.exist? ifil
            image = File.new ifil
            user.update_attributes(avatar: image, password: 'smso', password_confirmation: 'smso' )
            image.close
          end
        end
        # create membership record
        base_opts = {
          team_id: team.id,
          user_id: user.id
        }
        member_opts = base_opts.merge({rank: mem_arr[2]})
        next if Membership.where(base_opts).to_a.first
        next if member_opts[:rank].nil?
        FG.create(:membership, member_opts)
      end
    end

    def self.phones(path = 'data/seed/bamru/phones.csv')
      puts "\n-- Phones"
      CSV.read(path).each do |mem_arr|
        # find user record
        user_opts = {
          first_name: mem_arr[0],
          last_name:  mem_arr[1]
        }
        ppp
        user = User.where(user_opts).to_a.first || FG.create(:user, user_opts)
        # create phone record
        phone_opts = {
          user_id: user.id,
          typ:      mem_arr[2],
          number:   mem_arr[3],
          pagable:  mem_arr[4],
          position: mem_arr[5]
        }
        User::Phone.create phone_opts
      end
    end

    def self.emails(path = 'data/seed/bamru/emails.csv')
      puts "\n-- Emails"
      CSV.read(path).each do |mem_arr|
        # find user record
        user_opts = {
          first_name: mem_arr[0],
          last_name:  mem_arr[1]
        }
        ppp
        user = User.where(user_opts).to_a.first || FG.create(:user, user_opts)
        # create email record
        email_opts = {
          user_id: user.id,
          typ:      mem_arr[2],
          address:  mem_arr[3],
          pagable:  mem_arr[4],
          position: mem_arr[5]
        }
        User::Email.create email_opts
      end
    end

    def self.addresses(path = 'data/seed/bamru/addresses.csv')
      puts "\n-- Addresses"
      CSV.read(path).each do |mem_arr|
        # find user record
        user_opts = {
          first_name: mem_arr[0],
          last_name:  mem_arr[1]
        }
        ppp
        user = User.where(user_opts).to_a.first || FG.create(:user, user_opts)
        # create address record
        address_opts = {
          user_id: user.id,
          typ:      mem_arr[2],
          address1: mem_arr[3],
          address2: mem_arr[4],
          city:     mem_arr[5],
          state:    mem_arr[6],
          zip:      mem_arr[7],
          position: mem_arr[8]
        }
        UserAddress.create address_opts
      end
    end

    def self.certs(path = 'data/seed/bamru/certs.csv')
      puts "\n-- Certs"
      team = Team.where(:acronym => 'BAMRU').to_a.first
      CSV.read(path).each do |cert_arr|
        # create user record
        user_opts = {
          first_name: cert_arr[0],
          last_name:  cert_arr[1]
        }
        ppp
        user = User.where(user_opts).to_a.first || FG.create(:user, user_opts)
        base_opts = {
          team_id: team.id,
          user_id: user.id
        }
        member =  Membership.where(base_opts).to_a.first
        next if member.blank?
        uarr = {
          expires_at:  cert_arr[3],
          title:       cert_arr[4],
          comment:     cert_arr[5],
          link:        cert_arr[6]
        }
        doc_att = attachment_path(cert_arr[8])
        uarr.merge!({attachment: doc_att}) unless doc_att.blank?
        ucert = UserXcert.create uarr
        marr = {
          typ: normalize_type(cert_arr[2]),
          position: cert_arr[7],
          membership_id: member.id,
          user_cert_id: ucert.id
        }
        mcert = MembershipXcert.create marr
      end
    end

    def self.normalize_type(string)
      case string.upcase
        when 'MEDICAL'    then 'MED'
        when 'BACKGROUND' then 'SoBk'
        when 'DRIVER'     then 'SoDr'
        when 'AVALANCHE'  then 'AVY'
        else string.upcase
      end
    end

    def self.attachment_path(path)
      return '' if path == '/certs/original/missing.png'
      return '' if path.blank?
      return '' if path.length < 5
      new_path = path.split('?').first.split('[').first
      mod_path = Rails.root.to_s + '/data/seed/bamru' + new_path
      File.exist?(mod_path) ? File.open(mod_path) : ''
    end

    def self.others(path = 'data/seed/bamru/others.csv')
      puts "\n-- Others"
      CSV.read(path).each do |mem_arr|
        # find user record
        user_opts = {
          first_name: mem_arr[0],
          last_name:  mem_arr[1]
        }
        ppp
        user = User.where(user_opts).to_a.first || FG.create(:user, user_opts)
        team = Team.where(acronym: 'BAMRU').to_a.first
        membership = team.memberships.where(user_id: user.id).to_a.first
        next if membership.nil?
        membership.xfields = {'HAM' => mem_arr[2], 'V9' => mem_arr[3]}
        membership.save
      end
    end

  end
end
