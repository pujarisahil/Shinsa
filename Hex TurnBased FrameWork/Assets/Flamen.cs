using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Linq;


public class Flamen : shinsaUnit {

    /*
    public override List<Cell> GetAvailableDestinations(List<Cell> cells)
    {
        var ret = new List<Cell>();
        var cellsInMovementRange = cells.FindAll(c => IsCellMovableTo(c) && c.GetDistance(Cell) <= MovementPoints);

        var traversableCells = cells.FindAll(c => IsCellTraversable(c) && c.GetDistance(Cell) <= MovementPoints);
        traversableCells.Add(Cell);

        
        foreach (var cellInRange in cellsInMovementRange)
        {
            if (cellInRange.Equals(Cell)) continue;
            //if (cellInRange.GetDistance(Cell) % 2 == 0) continue;
            Debug.Log((Cell.transform.position - cellInRange.transform.position).normalized);

            if (!Hexagon._directions.Contains<Vector3>((Cell - cellInRange.transform.position).normalized)) continue;
            //if((Cell.transform.position - cellInRange.transform.position).normalized )

            Debug.Log("enter");
            var path = FindPath(traversableCells, cellInRange);
            var pathCost = path.Sum(c => c.MovementCost);
            if (pathCost > 0 && pathCost <= MovementPoints)
                ret.AddRange(path);
        }
        return ret.FindAll(IsCellMovableTo).Distinct().ToList();
        //return ret;
    }
    */
}
