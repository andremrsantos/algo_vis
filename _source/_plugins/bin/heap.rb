#!/usr/bin/env ruby
LIB_DIR = File.dirname(__FILE__) + '/../lib'
$:.unshift LIB_DIR unless $:.include? LIB_DIR

require 'data/heap'

f = DataStructure::Heap::BinaryHeap.new

(1..10).each {|i| f.push(i, 10*i)}

for i in 1..10
  f.pop
  f.change_key(10, 100-i*2) if f.contains?(10)
  puts f
  puts f.size
  puts
end