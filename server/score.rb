#!/usr/bin/ruby -w


# Public: Called before a match to calculate the expected score
#
# _p1_cur_score - Current score of player making request
# _p2_cur_score - Current score of opponent
#
# Returns expected score of player
#
def prematchScores(_p1_cur_score, _p2_cur_score)
	# Calculate transformed scores
	tp1 = 10**(_p1_cur_score / 400)
	tp2 = 10**(_p2_cur_score / 400)

	# Return expected scores
	return (tp1 / (tp1 + tp2))
end


# Public: Called after a match to calculate the new score
#
# _old_score - Players current score
# _exp_score - The expected score calculated in prematchScores()
# _games_played - The number of games the player has played
# _result - Result of the game (Win - 1, Tie - 0.5, Loss - 0)
#
# Returns the player's new score
#
def postmatchScores(_old_score, _exp_score, _games_played, _result)
	# Calculate k value
	if _games_played < 30 then
		k = 40
	elsif _old_score < 2400 then
		k = 20
	else
		k = 10
	end
	
	# Return new score
	return (_old_score + k * (_result - _exp_score))
end
