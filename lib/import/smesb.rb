require 'csv'

module Import
  class Smesb

    def self.ppp(string = '.')
      print string
      $stdout.flush
    end

    def self.all
      self.phones
      self.emails
      puts ' '
    end

    def self.phones(path = 'data/seed/smesb/phones.csv')
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
          pagable:  mem_arr[4] || '0',
          position: mem_arr[5]
        }
        User::Phone.create phone_opts
      end
    end

    def self.emails(path = 'data/seed/smesb/emails.csv')
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
          pagable:  mem_arr[4] || '0',
          position: mem_arr[5]
        }
        User::Email.create email_opts
      end
    end

  end
end
