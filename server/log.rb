#!/usr/bin/ruby -w

class Log
	def initialize(_player1, _player2)
		@player1 = _player1
		@player2 = _player2
		@entries = Array.new
	end

	def addToLog(_player, _pieceid, _startpos, _endpos)
		entry = LogEntry.new(_player, _pieceid, _startpos, _endpos)
		@entries.push(entry)
	end

	def getNumOfEntries()
		return @entries.size
	end

	def getEntry(i)
		return @entries[i]
	end

	def setWinner(player)
		@winner = player
	end

	def getWinner()
		return @winner
	end

	def setLoser(player)
		@loser = player
	end

	def getLoser()
		return @loser
	end

	def getPlayer1()
		return @player1
	end

	def getPlayer2()
		return @player2
	end

	def printLog()
		puts ""
		puts "----#@player1 vs. #@player2----"
		puts "Winner: #@winner"
		puts ""
		puts "PLAYER\tPIECE\tFROM\tTO"
		for i in 0..@entries.size-1
			puts "#{@entries[i].getPlayer()}\t#{@entries[i].getPieceId()}\t#{@entries[i].getStartPos()}\t#{@entries[i].getEndPos()}"
		end
	end
end

class LogEntry
	def initialize(_player, _pieceid, _startpos, _endpos)
		@player = _player
		@pieceid = _pieceid
		@startpos = _startpos
		@endpos = _endpos
	end

	def getPlayer()
		return @player
	end

	def getPieceId()
		return @pieceid
	end

	def getStartPos()
		return @startpos
	end

	def getEndPos()
		return @endpos
	end 
end
