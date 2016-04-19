using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class Archflamen : shinsaUnit {

	public override List<Cell> GetAvailableDestinations (List<Cell> cells)
	{
		return Cell.GetComponent<Hexagon> ().GetNeighbours (cells);
	}


	//if archflamen got captured, ends game
}
