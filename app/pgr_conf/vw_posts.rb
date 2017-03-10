class VwPosts
  def initialize(team)

  end

  private

  def load_assignments
    @assignments ||= assignments_scope.to_a
  end

  def assignments_scope
    Pgr::Assignment::AsPagingIndex.for_index(current_team)
  end

  def assignment_scope
    Pgr::Assignment::AsPagingIndex.for_show(current_team)
  end
end