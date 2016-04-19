using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine.Networking;

public class shinsaUnit : Unit
{
    public Color LeadingColor;
    public string UnitName;

	void Start(){
		PlayerNumber = -1;
	}

	public override void Move(Cell destinationCell, List<Cell> path){
		if (isMoving)
			return;
		Cell.IsTaken = false;
		Cell.setIndex (-1);
		if (destinationCell.playerIndex != PlayerNumber && destinationCell.playerIndex != -1) {
			Debug.Log ("shinsa Unit moves");
			OccupyEnemyCell (destinationCell);
		}

		this.Cell = destinationCell;
		destinationCell.IsTaken = true;
		destinationCell.setIndex (PlayerNumber);

		//transform.position = new Vector3 (Cell.transform.position.x, Cell.transform.position.y, transform.position.z);
		//CmdMoveIt (new Vector3 (Cell.transform.position.x, Cell.transform.position.y, transform.position.z));
		transform.position = new Vector3 (Cell.transform.position.x, Cell.transform.position.y, transform.position.z);
		Switch ();
		SetState(new UnitStateNormal(this));


		//this.OnUnitDeselected ();
		/*
		if (UnitMoved != null)
			UnitMoved.Invoke(this, new MovementEventArgs(Cell, destinationCell, path));    
		*/
	}

    public override void Initialize() {
        base.Initialize();
        transform.position += new Vector3(0, 0, -1);
        GetComponent<SpriteRenderer>().color = LeadingColor;
		Cell.setIndex (PlayerNumber);
		Cell.IsTaken = true;
		//ReachableEnemyCellList = new List<Cell> ();
		//setEnemyList ();
    }

    public override void MarkAsAttacking(Unit other)
    {
        throw new NotImplementedException();
    }

    public override void MarkAsDefending(Unit other)
    {
        throw new NotImplementedException();
    }

    public override void MarkAsDestroyed()
    {
		Debug.Log ("haha");
        //throw new NotImplementedException();
    }

    public override void MarkAsFinished()
    {
        //meObject.Find("CellGrid2").GetComponent<CellGrid>().EndTurn();
		Debug.LogWarning("fnnisss");
    }

    public override void MarkAsFriendly()
    {
        GetComponent<SpriteRenderer>().color = LeadingColor/* + new Color(0.8f, 1, 0.8f, 1f)*/;
    }

    public override void MarkAsReachableEnemy()
    {
        GetComponent<SpriteRenderer>().color = LeadingColor + Color.red;
    }

    public override void MarkAsSelected()
    {
        GetComponent<SpriteRenderer>().color = LeadingColor + Color.green;
        //Debug.Log("hahaha");
    }

    public override void UnMark()
    {
        GetComponent<SpriteRenderer>().color = LeadingColor;
    }

	public override bool IsUnitAttackable (Unit other, Cell sourceCell)
	{
		//return GetAvailableDestinations (_cellGrid.Cells).Contains (other.Cell);
		return true;
	}
		
	public void setNumber(int index){
		PlayerNumber = index;
	}

	public void Switch(){
		
		PhotonView view1 = this.gameObject.GetComponent<PhotonView> ();

		view1.RPC ("cellChange", PhotonTargets.Others, Cell.gameObject.name);
		view1.RPC ("ownerChange", PhotonTargets.Others, PhotonNetwork.otherPlayers[0].ID);
	}
		
	[PunRPC]
	public void ownerChange(int id){
		//this.gameObject.GetComponent<PhotonView> ().TransferOwnership(id);
		//!!disable all the colliders on Units when the current round is on the other side
		foreach (PhotonView a in transform.parent.GetComponentsInChildren<PhotonView>()) {
			a.TransferOwnership (id);
		}

	}

	//sync Cell in the Unit Script on the other side
	[PunRPC]
	public void cellChange(String cellID){
		Cell = GameObject.Find (cellID).GetComponent<Cell> ();
	}
}
