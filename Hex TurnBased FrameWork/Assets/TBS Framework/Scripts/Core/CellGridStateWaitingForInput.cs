using UnityEngine;

class CellGridStateWaitingForInput : CellGridState
{
    public CellGridStateWaitingForInput(CellGrid cellGrid) : base(cellGrid)
    {
    }

    public override void OnUnitClicked(Unit unit)
    {
		Debug.Log ("cell Grid Waiting for input");
		if(/*unit.PlayerNumber.Equals(_cellGrid.CurrentPlayerNumber)*/unit.PlayerNumber.Equals(PhotonNetwork.player.ID))
            _cellGrid.CellGridState = new CellGridStateUnitSelected(_cellGrid, unit); 
    }
}
