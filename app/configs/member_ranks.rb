require 'app_config/collection'

class MemberRanks < AppConfig::Collection

  def set_default_models
    return unless @collection.count == 0
    rad = MemberRank.new( position: 1,  label: 'OWN', name: 'Owner',    description: 'TBD', rights: 'owner'     )
    rdi = MemberRank.new( position: 2,  label: 'MGR', name: 'Manager',  description: 'TBD', rights: 'manager'    )
    rac = MemberRank.new( position: 3,  label: 'ACT', name: 'Active',   description: 'TBD', rights: 'active'    )
    rre = MemberRank.new( position: 4,  label: 'RES', name: 'Reserve',  description: 'TBD', rights: 'reserve'     )
    rgu = MemberRank.new( position: 6,  label: 'GST', name: 'Guest',    description: 'TBD', rights: 'guest'     )
    rin = MemberRank.new( position: 7,  label: 'INA', name: 'Inactive', description: 'TBD', rights: 'inactive'  )
    self.add_obj rad, rdi, rac, rre, rgu, rin
    self
  end

  def reorder
    own = to_a.select {|mdl| mdl.rights == 'owner'     }
    gst = to_a.select {|mdl| mdl.rights == 'manager'  }
    act = to_a.select {|mdl| mdl.rights == 'active'    }
    res = to_a.select {|mdl| mdl.rights == 'reserve'   }
    gst = to_a.select {|mdl| mdl.rights == 'guest'     }
    ina = to_a.select {|mdl| mdl.rights == 'inactive'  }
    alltyp = own + gst + act + res + gst + ina
    alltyp.each_with_index do |rank, idx|
      rank.position = idx + 1
    end
    self
  end

  def reserve_ranks
    self.to_data.values.select {|x| x[:rights] == 'reserve'}
  end

  def reserve_rank_names
    reserve_ranks.map {|x| x[:name]}
  end

  def reserve_rank_labels
    reserve_ranks.map {|x| x[:label]}
  end

end