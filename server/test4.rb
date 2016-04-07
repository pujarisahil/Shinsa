#!/usr/bin/ruby -w

testarray = Array.new(20)
puts "SIZE 1: #{testarray.size}"

for i in 0..19
	testarray[i] = i
end
puts "SIZE 2: #{testarray.size}"

for i in 10..19
	testarray[i] = nil
end
puts "SIZE 3: #{testarray.size}"

array = Array.new(10)
puts "SIZE 4: #{array.size}"

str = testarray.join(',')
puts "str: #{str}"

testarray = array
puts "SIZE 5: #{testarray.size}"
