# new_pgr

class Pgr::Send::Sms::NumberPool::Base

  class << self
    def nums
      raise 'IMPLEMENT IN SUBCLASS'
    end

    def numlist
      nums.split
    end

    def next(number)
      clean_num = sanitize_number(number)
      return numlist.first if clean_num.blank?
      return numlist.first unless numlist.include? clean_num
      return numlist.first if numlist.last == clean_num
      new_index = numlist.index(clean_num)+1
      numlist[new_index]
    end

    def random
      sanitize_number(numlist.sample)
    end

    private

    def sanitize_number(number)
      return '' if number.blank?
      clean_number = number.strip.gsub('-','').gsub(' ','')
      return '1' + clean_number if clean_number.length == 10
      clean_number
    end
  end
end