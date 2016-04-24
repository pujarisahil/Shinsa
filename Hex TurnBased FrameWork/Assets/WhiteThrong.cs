using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class WhiteThrong : shinsaUnit {

	public override List<Cell> GetAvailableDestinations(List<Cell> cells)
	{
		var ret = new List<Cell>();

		ret = Cell.GetComponent<Hexagon>().GetBackNeighbour(cells);
		ret.AddRange (Cell.GetComponent<Hexagon> ().GetEnemyOccupiedBackNeighbours (cells));
		return ret;
	}
}
