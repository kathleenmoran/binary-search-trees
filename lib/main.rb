require_relative 'tree'

def print_balanced(tree)
  puts "\nIs this tree balanced?"
  puts tree.balanced?
end

def print_orders(tree)
  puts "\nLevel order:"
  p tree.level_order
  puts "\nInorder:"
  p tree.inorder
  puts "\nPreorder:"
  p tree.preorder
  puts "\nPostorder:"
  p tree.postorder
end

tree = Tree.new(Array.new(15) { rand(1..100) })
puts "Randomly generated tree:"
tree.pretty_print
print_balanced(tree)
print_orders(tree)
tree.insert(rand(101..200))
tree.insert(rand(101..200))
tree.insert(rand(101..200))
tree.insert(rand(101..200))
tree.insert(rand(101..200))
puts "\nUnbalanced tree:"
tree.pretty_print
print_balanced(tree)
tree.rebalance
puts "\nBalanced tree:"
tree.pretty_print
print_balanced(tree)
print_orders(tree)
