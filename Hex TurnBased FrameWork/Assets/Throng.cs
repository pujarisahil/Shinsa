﻿using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class Throng : shinsaUnit {

    public override List<Cell> GetAvailableDestinations(List<Cell> cells)
    {
        var ret = new List<Cell>();

        ret = Cell.GetComponent<Hexagon>().GetFrontNeighbour(cells);

		ret.AddRange (Cell.GetComponent<Hexagon> ().GetEnemyOccupiedNeighbours (cells));
		return ret;
    }
}
