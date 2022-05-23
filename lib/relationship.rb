class Relationship
  attr_accessor :parent, :target, :direction

  def initialize(parent = nil, target = nil, direction = nil) 
    @parent = parent
    @target = target
    @direction = direction
  end

  def no_parent?
    @parent.nil?
  end

  def no_child?
    @child.nil?
  end

  def left?
    @direction == :left
  end

  def delete_target
    @parent.delete_child(@direction)
  end

  def childless_target?
    @target.childless?
  end

  def one_child_target?
    @target.one_child?
  end

  def target_single_child
    @target.single_child
  end

  def replace_target_with_target_child
    left? ? @parent.left = target_single_child : @parent.right = target_single_child
  end

  def target_data
    @target.data
  end
end