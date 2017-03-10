require_relative './model'

module AppAuth
  module Methods

    def view_rights() Model.new(v_rights); end
    def view_ranks()  Model.new(v_ranks) ; end
    def view_roles()  Model.new(v_roles) ; end
    def post_rights() Model.new(p_rights); end
    def post_ranks()  Model.new(p_ranks) ; end
    def post_roles()  Model.new(p_roles) ; end

    def view_rights=(model) self.v_rights = model.rights; end
    def post_rights=(model) self.p_rights = model.rights; end

    def view_ranks=(model)  self.v_ranks  = model.ranks ; end
    def post_ranks=(model)  self.p_ranks  = model.ranks ; end

    def view_roles=(model)  self.v_roles  = model.roles ; end
    def post_roles=(model)  self.p_roles  = model.roles ; end

    def view_ranks_array=(array)
      self.v_ranks = Model.new(Array(array).try(:join, ' ') || '').rights
    end

    def view_roles_array=(array)
      self.v_roles = Model.new(Array(array).try(:join, ' ') || '').rights
    end

    def post_ranks_array=(array)
      self.p_ranks = Model.new(Array(array).try(:join, ' ') || '').rights
    end

    def post_roles_array=(array)
      self.p_roles = Model.new(Array(array).try(:join, ' ') || '').rights
    end

    def set_perm(val, type, category)
      rights = self.send("#{category.to_s}_rights")
      if val == 'show'
        rights.set type
      else
        rights.del type
      end
      self.send("#{category.to_s}_rights=", rights)
    end

    def view_owner=(val)    set_perm(val, 'owner'   , :view)  ; end
    def view_manager=(val)  set_perm(val, 'manager',  :view)  ; end
    def view_active=(val)   set_perm(val, 'active'  , :view)  ; end
    def view_reserve=(val)  set_perm(val, 'reserve' , :view)  ; end
    def view_guest=(val)    set_perm(val, 'guest'   , :view)  ; end
    def view_alum=(val)     set_perm(val, 'alum'    , :view)  ; end

    def post_owner=(val)    set_perm(val, 'owner'   , :post)  ; end
    def post_manager=(val)  set_perm(val, 'manager' , :post)  ; end
    def post_active=(val)   set_perm(val, 'active'  , :post)  ; end
    def post_reserve=(val)  set_perm(val, 'reserve' , :post)  ; end
    def post_guest=(val)    set_perm(val, 'guest'   , :post)  ; end
    def post_alum=(val)     set_perm(val, 'alum'    , :post)  ; end

    def view_members
      rights = self.v_rights.try(:split, ' ') || []
      roles  = self.v_roles.try(:split, ' ')  || []
      ranks  = self.v_ranks.try(:split, ' ')  || []
      by_rights = team.memberships.where(rights: rights)
      by_roles  = team.memberships.where.overlap(roles: roles)
      by_ranks  = team.memberships.where(rank: ranks)
      (by_rights.to_a + by_roles.to_a + by_ranks.to_a).uniq
    end

    def post_members
      rights = self.p_rights.try(:split, ' ') || []
      roles  = self.p_roles.try(:split, ' ')  || []
      ranks  = self.p_ranks.try(:split, ' ')  || []
      query  = 'rights IN (?) OR roles && (?) OR rank IN (?)'
      team.memberships.where(query, rights, roles, ranks)
    end

    def sorted_post_members
      post_members.by_rank_score
    end

    def viewable_by(member)
      view_rights.has?(member.rights)  ||
        view_roles.has?(*member.roles) ||
        view_ranks.has?(*member.ranks)
    end

    def postable_by(member)
      post_rights.has?([member.rights]) ||
        post_roles.has?(*member.roles)  ||
        post_ranks.has?(*member.ranks)
    end

  end
end