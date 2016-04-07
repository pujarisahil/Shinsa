using UnityEngine;

class CellGridStateTurnChanging : CellGridState
{
    public CellGridStateTurnChanging(CellGrid cellGrid) : base(cellGrid)
    {
		//cellGrid.EndTurn ();
		Debug.LogWarning("turn changing");
    }
}

