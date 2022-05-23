# frozen_string_literal: true

require_relative 'node'
require_relative 'relationship'

# a binary search tree
class Tree
  attr_accessor :root

  def initialize(elements)
    @root = elements.nil? ? nil : build_tree(elements.uniq.sort)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = @root)
    return self unless find(value).nil?

    if node.nil?
      @root = Node.new(value)
    elsif value < node.data
      insert_left(value, node)
    else
      insert_right(value, node)
    end
    self
  end

  def level_order(node = @root)
    return if node.nil?

    queue = []
    breadth_first_order = []
    queue.prepend(node)
    until queue.empty?
      new_node = queue.pop
      if block_given?
        yield new_node
      else
        breadth_first_order << new_node.data
      end
      queue.prepend(new_node.left) unless new_node.no_left?
      queue.prepend(new_node.right) unless new_node.no_right?
    end
    breadth_first_order unless block_given?
  end

  def inorder(node = @root, values = [], &block)
    return unless node

    inorder(node.left, values)
    values << node
    inorder(node.right, values)
    yield_or_return_values(values, &block)
  end

  def preorder(node = @root, values = [], &block)
    return unless node

    values << node
    preorder(node.left, values)
    preorder(node.right, values)
    yield_or_return_values(values, &block)
  end

  def postorder(node = @root, values = [], &block)
    return unless node

    postorder(node.left, values)
    postorder(node.right, values)
    values << node
    yield_or_return_values(values, &block)
  end

  def yield_or_return_values(values, &block)
    if block_given?
      values.each(&block)
    else
      values.map(&:data)
    end
  end

  def balanced?
    (height(root.left) - height(root.right)).abs <= 1
  end

  def rebalance
    @root = build_tree(level_order)
    self
  end

  private

  def build_tree(elements)
    size = elements.length
    if size.zero?
      nil
    elsif size == 1
      Node.new(elements[0])
    else
      Node.new(elements[size / 2], build_tree(elements[0...size / 2]), build_tree(elements[size / 2 + 1..size]))
    end
  end

  def insert_left(value, node = @root)
    node.no_left? ? (node.left = Node.new(value)) : insert(value, node.left)
  end

  def insert_right(value, node = @root)
    node.no_right? ? (node.right = Node.new(value)) : insert(value, node.right)
  end


  def delete_no_children(relationship)
    if relationship.no_parent?
      @root = nil
    else
      relationship.delete_target
    end
  end

  def delete_one_child(relationship)
    if relationship.no_parent?
      @root = relationship.target_single_child
    else
      relationship.replace_target_with_target_child
    end
  end

  def delete_two_children(relationship)
    predecessor_relationship = inorder_predecessor_relationship(relationship.target)
    if relationship.no_parent?
      @root.data = predecessor_relationship.target_data
    else
      relationship.target_data = predecessor_relationship.target_data
    end
    predecessor_relationship.replace_target_with_target_child
  end

  def find_rightmost_relationship(node = @root)
    return Relationship.new if node.nil? || node.right.nil?
    return Relationship.new(node, node.right, :right) if node.right_no_right?

    find_rightmost(node.right)
  end

  def find(value, node = @root)
    find_relationship(value, node).target
  end

  def find_parent(value, node = @root)
    return nil if node.nil? || node.data == value
    return node if [node.left_data, node.right_data].include?(value)

    value < node.data ? find_parent(value, node.left) : find_parent(value, node.right)
  end

  def find_child(value, parent)
    if parent.nil?
      @root&.data == value ? [@root, nil] : [nil, nil]
    else
      parent.left_data == value ? [parent.left, :left] : [parent.right, :right]
    end
  end

  def find_relationship(value, node = @root)
    parent = find_parent(value, node)
    child_and_side = find_child(value, parent)
    Relationship.new(parent, child_and_side[0], child_and_side[1])
  end

  def inorder_predecessor_relationship(node = @root)
    return Relationship.new if node.nil? || node.no_left?
    return Relationship.new(node, node.left, :left) if node.left_no_right?

    find_rightmost_relationship(node.left)
  end

  def height(node = @root)
    return 0 unless node

    left_max_height = height(node.left)
    right_max_height = height(node.right)
    [left_max_height, right_max_height].max + 1
  end

  def depth(node, root = @root, acc = 0)
    return unless root
    return acc if node.data == root.data

    left_search = depth(node, root.left, acc + 1) if node.data < root.data
    right_search = depth(node, root.right, acc + 1) if node.data > root.data
    left_search.nil? ? right_search : left_search
  end
end
