using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class Throng : shinsaUnit {

    public override List<Cell> GetAvailableDestinations(List<Cell> cells)
    {
		//Debug.Log ("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
        var ret = new List<Cell>();

        ret = Cell.GetComponent<Hexagon>().Get3LineNeighbours(cells);

		Debug.Log ("occ neighb"+ Cell.GetComponent<Hexagon> ().GetEnemyOccupiedNeighbours (cells).Count);
		ret.AddRange (Cell.GetComponent<Hexagon> ().GetEnemyOccupiedNeighbours (cells));

		Debug.Log ("It has " + ret.Count);

        //return cellsInMovementRange;
		return ret;
    }
}
