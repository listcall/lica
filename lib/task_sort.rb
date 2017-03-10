require 'tsort'

class TaskSort < Hash
  include TSort

  def root_tasks=(keys)
    @root_tasks = Array(keys).map(&:to_sym)
  end

  def root_tasks
    @root_tasks || keys
  end

  private

  def tsort_each_node(&block)
    root_tasks.each(&block)
  end

  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end
