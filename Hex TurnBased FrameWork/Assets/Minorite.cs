using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;

public class Minorite : shinsaUnit {

    public override List<Cell> GetAvailableDestinations(List<Cell> cells)
    {
        var ret = new List<Cell>();
        var cellsInMovementRange = cells.FindAll(c => IsCellMovableTo(c) && c.GetDistance(Cell) <= MovementPoints);

        var traversableCells = cells.FindAll(c => IsCellTraversable(c) && c.GetDistance(Cell) <= MovementPoints);
        traversableCells.Add(Cell);

        foreach (var cellInRange in cellsInMovementRange)
        {
            if (cellInRange.Equals(Cell)) continue;

            if (cellInRange.gameObject.GetComponent<SpriteRenderer>().color == Cell.gameObject.GetComponent<SpriteRenderer>().color)
                ret.Add(cellInRange);

        }
        return ret;
    }

}
