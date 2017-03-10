class VwAssignments

  attr_reader :team

  def initialize(team = nil)
    @team = team
  end

  def assignments
    @loaded_assignments ||= assignments_scope.to_a
  end

  private

  def assignments_scope
    Pgr::Assignment::AsPagingIndex.for(team)
  end
end