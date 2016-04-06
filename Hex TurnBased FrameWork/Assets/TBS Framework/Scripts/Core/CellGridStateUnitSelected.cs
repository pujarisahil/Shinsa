using System.Collections.Generic;
using System.Linq;
using UnityEngine;

class CellGridStateUnitSelected : CellGridState
{
    private Unit _unit;
    private List<Cell> _pathsInRange;
    private List<Unit> _unitsInRange;

    private Cell _unitCell;

    public CellGridStateUnitSelected(CellGrid cellGrid, Unit unit) : base(cellGrid)
    {
        _unit = unit;
        _pathsInRange = new List<Cell>();
        _unitsInRange = new List<Unit>();
    }

    public override void OnCellClicked(Cell cell)
    {
        if (_unit.isMoving)
            return;
		if(cell.IsTaken && cell.playerIndex == _unit.PlayerNumber)
        {
            _cellGrid.CellGridState = new CellGridStateWaitingForInput(_cellGrid);
            return;
        }
            
        if(!_pathsInRange.Contains(cell))
        {
            _cellGrid.CellGridState = new CellGridStateWaitingForInput(_cellGrid);
        }
        else
        {
			var path = _unit.FindPath(_unit.GetAvailableDestinations(_cellGrid.Cells), cell);
            _unit.Move(cell,path);
			_cellGrid.CellGridState = new CellGridStateWaitingForInput (_cellGrid);
            //_cellGrid.CellGridState = new CellGridStateUnitSelected(_cellGrid, _unit);
        }
    }
    public override void OnUnitClicked(Unit unit)
    {
		Debug.Log ("ZZ");
        if (unit.Equals(_unit) || unit.isMoving)
            return;

		//check if unit is in its reachableEnemyList. if yes move. if no deny player
		if (_unit.GetAvailableDestinations(_cellGrid.Cells).Contains(unit.Cell) && _unit.ActionPoints > 0)
        {
			Debug.LogWarning ("sdadsa");
			//_unit.DealDamage(unit);
			_unit.Move(unit.Cell,_unit.FindPath(_cellGrid.Cells, unit.Cell));
           // _cellGrid.CellGridState = new CellGridStateUnitSelected(_cellGrid, _unit);
			_cellGrid.CellGridState = new CellGridStateWaitingForInput (_cellGrid);
        }

        if (unit.PlayerNumber.Equals(_unit.PlayerNumber))
        {
			Debug.LogWarning ("this is equal");
            _cellGrid.CellGridState = new CellGridStateUnitSelected(_cellGrid, unit);
        }
            
    }
    public override void OnCellDeselected(Cell cell)
    {
        base.OnCellDeselected(cell);

        foreach (var _cell in _pathsInRange)
        {
            _cell.MarkAsReachable();
        }
        foreach (var _cell in _cellGrid.Cells.Except(_pathsInRange))
        {
            _cell.UnMark();
        }
    }
    public override void OnCellSelected(Cell cell)
    {
		base.OnCellSelected (cell);
		if (!_pathsInRange.Contains (cell))
				return;
		//var path = _unit.FindPath(_cellGrid.Cells, cell);       
		/*foreach (var _cell in path)
        {
            _cell.MarkAsPath();
        }
        */
    }

    public override void OnStateEnter()
    {
        base.OnStateEnter();

		Debug.Log("Mark as ");
        _unit.OnUnitSelected();
        _unitCell = _unit.Cell;

        _pathsInRange = _unit.GetAvailableDestinations(_cellGrid.Cells);
        var cellsNotInRange = _cellGrid.Cells.Except(_pathsInRange);

        foreach (var cell in cellsNotInRange)
        {
            cell.UnMark();
        }

        foreach (var cell in _pathsInRange)
        {
            cell.MarkAsReachable();
        }

        if (_unit.ActionPoints <= 0) return;

        foreach (var currentUnit in _cellGrid.Units)
        {
            if (currentUnit.PlayerNumber.Equals(_unit.PlayerNumber))
                continue;
        
			if (_unit.IsUnitAttackable(currentUnit,_unit.Cell))
            {
                currentUnit.SetState(new UnitStateMarkedAsReachableEnemy(currentUnit));
                _unitsInRange.Add(currentUnit);
            }
        }
        
        if (_unitCell.GetNeighbours(_cellGrid.Cells).FindAll(c => c.MovementCost <= _unit.MovementPoints).Count == 0 
            && _unitsInRange.Count == 0)
            _unit.SetState(new UnitStateMarkedAsFinished(_unit));
    }
    public override void OnStateExit()
    {
        _unit.OnUnitDeselected();
        foreach (var unit in _unitsInRange)
        {
            if (unit == null) continue;
            unit.SetState(new UnitStateNormal(unit));
        }
        foreach (var cell in _cellGrid.Cells)
        {
            cell.UnMark();
        }   
    }
}

