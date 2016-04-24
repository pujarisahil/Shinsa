using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class Minorite : shinsaUnit {

    public override List<Cell> GetAvailableDestinations(List<Cell> cells)
    {
		return Cell.GetComponent<Hexagon> ().GetMinoriteCells (cells);
}

}
