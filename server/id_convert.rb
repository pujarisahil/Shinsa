#!/usr/bin/ruby -w

# Public: Converts the base 66 id to base 10
#
# id - Integer to convert from base 62 to base 10
#
# Returns converted number
#
def con62to10(id)
	new_id = 0
	for i in 0..3
		c = id.getbyte(i)
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
		new_id += num * 62**(3 - i)
	end
	return Integer(new_id)
end

# Public: Converts the base 10 id to base 62
#
# id - Integer to convert from base 10 to base 62
#
# Returns converted number
#
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
