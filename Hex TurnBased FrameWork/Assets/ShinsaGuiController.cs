using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System;

public class ShinsaGuiController : MonoBehaviour {
	public CellGrid CellGrid;
	public GameObject UnitsParent;
	public photonNetworkManager networkManager;

	public Image UnitImage;
	public Sprite[] UnitImagePool;
	public Text InfoText;
	public Text StatsText;



	public Material highlightingMaterial;
	public Material UnitDefaultMaterial;


	// Use this for initialization
	void Start () {
		Time.timeScale = 1f;
		CellGrid.GameStarted += OnGameStarted;
		CellGrid.TurnEnded += OnTurnEnded;   
		CellGrid.GameEnded += OnGameEnded;
	}

	private void OnGameStarted(object sender, EventArgs e)
	{
		foreach (Transform unit in UnitsParent.transform)
		{
			unit.GetComponent<Unit>().UnitHighlighted += OnUnitHighlighted;
			unit.GetComponent<Unit>().UnitDehighlighted += OnUnitDehighlighted;
		}

		foreach (Transform cell in CellGrid.transform)
		{
			cell.GetComponent<Cell>().CellHighlighted += OnCellHighlighted;
			cell.GetComponent<Cell>().CellDehighlighted += OnCellDehighlighted;
		}

		OnTurnEnded(sender,e);
	}
		

	private void OnGameEnded(object sender, EventArgs e){
		networkManager.gameObject.GetComponent<PhotonView> ().RPC ("WinAndLoss", PhotonTargets.All, (sender as shinsaUnit).PlayerNumber);
	}
	private void OnTurnEnded(object sender, EventArgs e){

	}


	/// <summary>
	/// (Deprecated)Raises the cell dehighlighted event.
	/// </summary>
	private void OnCellDehighlighted(object sender, EventArgs e)
	{
		StatsText.text = "";
	}

	/// <summary>
	/// (Deprecated)Raises the cell highlighted event.
	/// </summary>
	private void OnCellHighlighted(object sender, EventArgs e)
	{
		StatsText.text = "";
	}

	private void OnUnitDehighlighted(object sender, EventArgs e)
	{
		var unit = sender as shinsaUnit;
		if (unit.PlayerNumber == CellGrid.CurrentPlayerNumber) {
			StatsText.text = "";
			swapPicts (sender as shinsaUnit, false);
			swapMaterial (sender as shinsaUnit, false);
		}
	}
	private void OnUnitHighlighted(object sender, EventArgs e)
	{
		var unit = sender as shinsaUnit;
		if (unit.PlayerNumber == CellGrid.CurrentPlayerNumber) {
			swapPicts (unit, true);
			StatsText.text = unit.UnitName;
			swapMaterial (sender as shinsaUnit, true);
		}
	}

	private void swapMaterial(shinsaUnit a, bool highlightIt){
		if (highlightIt) {
			a.GetComponent<SpriteRenderer> ().material = highlightingMaterial;
		} else {
			a.GetComponent<SpriteRenderer> ().material = UnitDefaultMaterial;
		}
	}

	private void swapPicts(shinsaUnit unit, bool toImage)
	{
		if (unit.UnitName == "Archflamen" && toImage) {
			UnitImage.sprite = UnitImagePool [0];
		} else if (unit.UnitName == "Throng" && toImage) {
			UnitImage.sprite = UnitImagePool [1];
		} else if (unit.UnitName == "Flamen" && toImage) {
			UnitImage.sprite = UnitImagePool [2];
		} else if (unit.UnitName == "Minorite" && toImage)
			UnitImage.sprite = UnitImagePool [3];
		else if (unit.UnitName == "Preceptor" && toImage)
			UnitImage.sprite = UnitImagePool [4];
		else if (unit.UnitName == "HighPerceptor" && toImage)
			UnitImage.sprite = UnitImagePool [5];
		if (!toImage)
		{
			UnitImage.sprite = UnitImagePool [6];
		}
	}



}
