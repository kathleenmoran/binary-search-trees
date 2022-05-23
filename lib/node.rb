# frozen_string_literal: true

# an element of a binary search tree
class Node
  attr_accessor :data, :left, :right

  def initialize(data, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end

  def delete_child(direction)
    @left = nil if direction == :left
    @right = nil if direction == :right
  end

  def childless?
    @left.nil? && @right.nil?
  end

  def one_child?
    (!@left.nil? && @right.nil?) || (@left.nil? && !@right.nil?)
  end

  def single_child
    @left.nil? ? @right : @left
  end

  def no_left?
    @left.nil?
  end

  def no_right?
    @right.nil?
  end

  def left_no_right?
    @left.no_right?
  end

  def right_no_right?
    @right.no_right?
  end

  def left_data
    @left&.data
  end

  def right_data
    @right&.data
  end
end
