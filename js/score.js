/* Called before a match begins

	myCurScore - The current score of the player calling the function
	oppCurScore - The current score of the opponent
	
	Returns the "expected score" of the player making the call

	**** BOTH PLAYERS MUST CALL THIS FUNCTION TO GET EACH OF THEIR
	EXPECTED SCORES BEFORE THE MATCH BEGINS ****
*/

function prematchScores(myCurScore, oppCurScore) {
	// Calculate the transformed scores
	var tp1 = Math.pow(10, (myCurScore / 400));
	var tp2 = Math.pow(10, (oppCurScore / 400));

	// Calculate the expected score
	var myExpScore = (tp1 / (tp1 + tp2));

	// Return the expected score
	return myExpScore;
}


/* Called after a match ends

	myCurScore - The current score of the player calling the function
	myExpScore - The expected score of the player calling the function
	myGamesPlayed - The number of games that the player has played
	outcome - Result of the game (Win = 1, Tie = 0.5, Loss = 0)

	Returns the player's new score

	**** BOTH PLAYERS MUST CALL THIS FUNCTION TO GET EACH OF THEIR NEW
	SCORES AFTER THE MATCH HAS ENDED ****
*/

function postmatchScores(myCurScore, myExpScore, myGamesPlayed, outcome) {
	// Calculate the k value
	var k = 10;
	if (myGamesPlayed < 30) {
		k = 40;
	} else if (myCurScore < 2400) {
		k = 20;
	}

	// Calculate the new score
	var newScore = (myCurScore + k * (outcome - myExpScore));

	// Return new score
	return newScore;
}
