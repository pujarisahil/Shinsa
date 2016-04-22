using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class Archflamen : shinsaUnit {

	public override List<Cell> GetAvailableDestinations (List<Cell> cells)
	{
		var ret = new List<Cell> ();
		foreach (Cell c in Cell.GetComponent<Hexagon> ().GetNeighbours (cells)) {
			if (c.playerIndex == Cell.playerIndex)
				continue;
			else
				ret.Add (c);
		}
		return ret;
	}
	//if archflamen got captured, ends game
}
