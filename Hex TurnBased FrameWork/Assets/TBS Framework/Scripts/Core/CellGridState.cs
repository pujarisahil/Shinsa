using System.Linq;
using UnityEngine;

public abstract class CellGridState
{
    protected CellGrid _cellGrid;
    
    protected CellGridState(CellGrid cellGrid)
    {
        _cellGrid = cellGrid;
    }

    public virtual void OnUnitClicked(Unit unit)
	{
		Debug.Log ("CellGridState: OnUnitClicked");
	}
    
    public virtual void OnCellDeselected(Cell cell)
    {
        cell.UnMark();
    }
    public virtual void OnCellSelected(Cell cell)
    {
		cell.MarkAsHighlighted ();
    }
    public virtual void OnCellClicked(Cell cell)
    { }

    public virtual void OnStateEnter()
    {
		//Check the number of the player at the beginning of the game
        if (_cellGrid.Units.Select(u => u.PlayerNumber).Distinct().ToList().Count == 1)
        {
            _cellGrid.CellGridState = new CellGridStateGameOver(_cellGrid);
        }
    }
    public virtual void OnStateExit()
    {
    }
}