# new_pgr

class Pgr < ActiveRecord::Base

  opts = {:dependent => :destroy, :foreign_key => :pgr_id}
  belongs_to :team
  has_many   :assignments       , opts.merge(:class_name => 'Pgr::Assignment')
  has_many   :paging_assignments, opts.merge(:class_name => 'Pgr::Assignment::AsPagingShow')
  has_many   :broadcasts        ,  :through   => :assignments

  # ----- scopes ----

  def assignments_w_broadcast
    opts = {:pgr_broadcast => {:sender => [:user, {:team => :org}]}}
    pgr_assignments.includes(opts)
  end

  # ----- local methods -----

  def from_name
    "#{team.acronym} Pager"
  end

  def email_address
    team.fqdn
  end

  def from_email
    "pgr@#{email_address}"
  end

end

# == Schema Information
#
# Table name: pgrs
#
#  id         :integer          not null, primary key
#  team_id    :integer
#  created_at :datetime
#  updated_at :datetime
#
