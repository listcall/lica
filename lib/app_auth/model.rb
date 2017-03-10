module AppAuth
  class Model

    attr_reader :rights

    def initialize(rights)
      @rights = rights || ''
    end

    def set(*rights)
      current = @rights.try(:split) || []
      new     = rights.reject { |right| current.include? right }
      @rights = (current + new).uniq.join(' ')
      self
    end

    def del(*delete_rights)
      @rights = (@rights.split.reject {|old_right| delete_rights.include? old_right}).join(' ')
      self
    end

    def has?(*rights)
      current = Set.new @rights.try(:split)
      test    = Set.new rights
      (current & test).present?
    end

    def values
      @rights.split.join(', ')
    end

  end
end