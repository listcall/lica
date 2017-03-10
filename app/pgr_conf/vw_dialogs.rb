class VwDialogs

  attr_reader :team

  def initialize(team)
    @assigs = {}
    @team   = team
  end

  def assignment_for(seq_id)
    @assigs[seq_id] ||= Pgr::Assignment::AsPagingIndex.for(team).find_by(sequential_id: seq_id)
  end

  def dialogs_for(assignment)
    opts = [:broadcast, {:recipient => [:user, :team]}]
    assignment.broadcast.dialogs.becomes(Pgr::Dialog::AsPaging).includes(opts).to_a
  end
end