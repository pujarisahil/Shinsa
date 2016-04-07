using System;
using UnityEngine;
using UnityEngine.UI;

public class GuiController : MonoBehaviour
{
    public CellGrid CellGrid;
    public GameObject UnitsParent;
    public Button NextTurnButton;

    public Image UnitImage;
    public Sprite[] UnitImagePool;
    public Text InfoText;
    public Text StatsText;

    public GameObject winPanel;
    public GameObject lossPanel;

	public Material UnitHighlightingMaterial;
	public Material UnitDefaultMaterial;

    void Start()
    {
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
            unit.GetComponent<Unit>().UnitAttacked += OnUnitAttacked;
        }

        foreach (Transform cell in CellGrid.transform)
        {
            cell.GetComponent<Cell>().CellHighlighted += OnCellHighlighted;
            cell.GetComponent<Cell>().CellDehighlighted += OnCellDehighlighted;
        }

        OnTurnEnded(sender,e);
    }

    public void surrender()
    {
        Time.timeScale = 0f;
        if (CellGrid.CurrentPlayerNumber == 0)
        {
            lossPanel.SetActive(true);
        }
        else
        {
            winPanel.SetActive(true);
        }
    }

    private void OnGameEnded(object sender, EventArgs e)
    {
        InfoText.text = "Player " + ((sender as CellGrid).CurrentPlayerNumber + 1) + " wins!";
    }
    private void OnTurnEnded(object sender, EventArgs e)
    {
        NextTurnButton.interactable = ((sender as CellGrid).CurrentPlayer is HumanPlayer);

        InfoText.text = "Player " + ((sender as CellGrid).CurrentPlayerNumber +1);
    }
    private void OnCellDehighlighted(object sender, EventArgs e)
    {
        //UnitImage.color = Color.gray;
        StatsText.text = "";
    }
    private void OnCellHighlighted(object sender, EventArgs e)
    {
        //UnitImage.color = Color.gray;
        StatsText.text = "Movement Cost: " + (sender as Cell).MovementCost;
    }

	/// <summary>
	/// Raises the unit attacked event.(deprecated)
	/// </summary>
	/// <param name="sender">Sender.</param>
	/// <param name="e">E.</param>
    private void OnUnitAttacked(object sender, AttackEventArgs e)
    {
        if (!(CellGrid.CurrentPlayer is HumanPlayer)) return;
        OnUnitDehighlighted(sender, new EventArgs());

        if ((sender as Unit).HitPoints <= 0) return;

        OnUnitHighlighted(sender, e);
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
			StatsText.text = unit.UnitName /*+ "\nHit Points: " + unit.HitPoints +"/"+unit.TotalHitPoints + "\nAttack: " + unit.AttackFactor + "\nDefence: " + unit.DefenceFactor + */ + "\n Range:" + unit.AttackRange;
			swapMaterial (sender as shinsaUnit, true);
		}
    }

	/// <summary>
	/// Swaps to highlighting material.
	/// </summary>
	/// <param name="a">The alpha component.</param>
	/// <param name="highlightIt">If set to <c>true</c> highlight it.</param>
	private void swapMaterial(shinsaUnit a, bool highlightIt){
		if (highlightIt) {
			a.GetComponent<SpriteRenderer> ().material = UnitHighlightingMaterial;
		} else {
			a.GetComponent<SpriteRenderer> ().material = UnitDefaultMaterial;
		}
	}

    private void swapPicts(shinsaUnit unit, bool toImage)
    {
        if(unit.UnitName == "Archflamen" && toImage)
        {
            UnitImage.sprite = UnitImagePool[0];
        }
        else if(unit.UnitName == "Throng" && toImage)
        {
            UnitImage.sprite = UnitImagePool[1];
        }
        else if (unit.UnitName == "Flamen" && toImage)
        {
            UnitImage.sprite = UnitImagePool[2];
        }
        if (!toImage)
        {
            UnitImage.sprite = UnitImagePool[UnitImagePool.Length - 1];
        }
    }


    public void RestartLevel()
    {
        Application.LoadLevel(Application.loadedLevel);
    }
}
