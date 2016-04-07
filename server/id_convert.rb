#!/usr/bin/ruby -w

#converts the base 66 id to base 10
def con62to10(id)
	new_id = 0
	for i in 0..3
		c = id.getbyte(i)
		puts "char: #{c}"
		if c > 47 && c < 58
			#0-9
			num = c - 48
		elsif c > 64 && c < 91
			#A-Z
			num = c - 55
		elsif c > 96 && c < 123
			#a-z
			num = c - 36
		else
			#error
			return -1
		end
		puts "new val: #{num}"
		new_id += num * 62**(3 - i)
	end
	return Integer(new_id)
end

#converts the base 10 id to base 66
def con10to62(id)
	new_id = "0000"
	for i in 0..3
		div = id / 62**(3 - i)
		if div > -1 && div < 10
			#0-9
			new_id.setbyte(i, (div + 48))
		elsif div > 9 && div < 36
			#A-Z
			new_id.setbyte(i, (div + 55))
		elsif div > 35 && div < 62
			#a-z
			new_id.setbyte(i, (div + 36))
		else
			#error
			return -1
		end
		id = id % 62**(3 - i)
	end
	return new_id
end
