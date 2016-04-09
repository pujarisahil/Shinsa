#!/usr/bin/ruby -w

require_relative 'searchPlayers'

puts ""
puts "    SEARCH: j"
puts ""

matches = searchPlayers("j")

for i in 0..(matches.size - 1)
	puts "--------------------------------"
	puts "  #{matches[i][0]}: Score #{matches[i][3]}"
	puts "  #{matches[i][1]} #{matches[i][2]}"
end
puts "--------------------------------"
puts ""
