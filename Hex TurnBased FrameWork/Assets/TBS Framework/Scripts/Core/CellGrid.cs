using UnityEngine;
using System.Collections.Generic;
using System.Linq;
using System;

/// <summary>
/// CellGrid class keeps track of the game, stores cells, units and players objects. It starts the game and makes turn transitions. 
/// It reacts to user interacting with units or cells, and raises events related to game progress. 
/// </summary>
public class CellGrid : MonoBehaviour
{
	public bool boolLock = false;

	public AudioClip clickSound;
	public AudioClip turnSound;
	private AudioSource audio;

	public event EventHandler GameStarted;
    public event EventHandler GameEnded;
    public event EventHandler TurnEnded;
    
    private CellGridState _cellGridState;//The grid delegates some of its behaviours to cellGridState object.
    public CellGridState CellGridState
    {
        private get
        {
            return _cellGridState;
        }
        set
        {
            if(_cellGridState != null)
                _cellGridState.OnStateExit();
            _cellGridState = value;
            _cellGridState.OnStateEnter();
        }
    }

    public int NumberOfPlayers { get; private set; }

    public Player CurrentPlayer
    {
        get { return Players.Find(p => p.PlayerNumber.Equals(CurrentPlayerNumber)); }
    }
    public int CurrentPlayerNumber { get; private set; }

    public Transform PlayersParent;

    public List<Player> Players { get; private set; }
    public List<Cell> Cells { get; private set; }
    public List<Unit> Units { get; private set; }

    void Start()
    {
        Players = new List<Player>();
        for (int i = 0; i < PlayersParent.childCount; i++)
        {
            var player = PlayersParent.GetChild(i).GetComponent<Player>();
            if (player != null)
                Players.Add(player);
            else
                Debug.LogError("Invalid object in Players Parent game object");
        }
        NumberOfPlayers = Players.Count;
        CurrentPlayerNumber = Players.Min(p => p.PlayerNumber);

        Cells = new List<Cell>();
        for (int i = 0; i < transform.childCount; i++)
        {
            var cell = transform.GetChild(i).gameObject.GetComponent<Cell>();
            if (cell != null)
                Cells.Add(cell);
            else
                Debug.LogError("Invalid object in cells paretn game object");
        }
      
        foreach (var cell in Cells)
        {
            cell.CellClicked += OnCellClicked;
            cell.CellHighlighted += OnCellHighlighted;
            cell.CellDehighlighted += OnCellDehighlighted;
        }
             
        var unitGenerator = GetComponent<IUnitGenerator>();
        if (unitGenerator != null)
        {
            Units = unitGenerator.SpawnUnits(Cells);
            foreach (var unit in Units)
            {
                unit.UnitClicked += OnUnitClicked;
                unit.UnitDestroyed += OnUnitDestroyed;
            }
        }
        else
            Debug.LogError("No IUnitGenerator script attached to cell grid");
        
		audio = GetComponent<AudioSource> ();
        StartGame();
    }


	public void removeCellEvent(){
		foreach (var cell in Cells)
		{
			cell.CellClicked -= OnCellClicked;
			cell.CellHighlighted -= OnCellHighlighted;
			cell.CellDehighlighted -= OnCellDehighlighted;
		}
	}
	private void playAudio(AudioClip clip){
		audio.clip = clip;
		audio.Play ();
	}

    private void OnCellDehighlighted(object sender, EventArgs e)
    {
        CellGridState.OnCellDeselected(sender as Cell);
    }
    private void OnCellHighlighted(object sender, EventArgs e)
    {
        CellGridState.OnCellSelected(sender as Cell);
    } 
    private void OnCellClicked(object sender, EventArgs e)
    {
        CellGridState.OnCellClicked(sender as Cell);
    }

    private void OnUnitClicked(object sender, EventArgs e)
    {
		playAudio (clickSound);
        CellGridState.OnUnitClicked(sender as Unit);
    }

    private void OnUnitDestroyed(object sender, AttackEventArgs e)
    {
		if ((sender as shinsaUnit).UnitName == "Archflamen") {
			if(GameEnded != null)
				GameEnded.Invoke(sender, new EventArgs());
		}
    }


    /// <summary>
    /// Method is called once, at the beggining of the game.
    /// </summary>
    public void StartGame()
    {
        if(GameStarted != null)
            GameStarted.Invoke(this, new EventArgs());

		CurrentPlayerNumber = GameObject.Find ("NetworkManager").GetComponent<photonNetworkManager> ().currentTurnOwner;
		if (photonNetworkManager.thisPlayerNumber == CurrentPlayerNumber) {
			Units.FindAll (u => u.PlayerNumber.Equals (CurrentPlayerNumber)).ForEach (u => {
				u.OnTurnStart ();
			});
			Players.Find (p => p.PlayerNumber.Equals (CurrentPlayerNumber)).Play (this);
		}

    }
    /// <summary>
    /// Method makes turn transitions. It is called by player at the end of his turn.
    /// </summary>
    public void EndTurn()
    {
		
        if (Units.Select(u => u.PlayerNumber).Distinct().Count() == 1)
        {
            return;
        }
        CellGridState = new CellGridStateTurnChanging(this);
		//Units.FindAll(u => u.PlayerNumber.Equals(CurrentPlayerNumber)).ForEach(u => { u.OnTurnEnd(); });
		Units.FindAll(u => u.PlayerNumber.Equals(PhotonNetwork.player.ID)).ForEach(u => { u.OnTurnEnd(); });


        if (TurnEnded != null)
            TurnEnded.Invoke(this, new EventArgs());
		
		//Debug.Log ("this reaches to here!@#WEAAFWFEFAWEFADASAEFA");
		//GameObject.Find ("NetworkManager").GetComponent<photonNetworkManager> ().changeTurnOnFly ();
		playAudio(turnSound);
		GameObject.Find ("NetworkManager").GetComponent<PhotonView> ().RPC ("changeTurnOnFly",PhotonTargets.All);
		boolLock = false;
		CurrentPlayerNumber = GameObject.Find ("NetworkManager").GetComponent<photonNetworkManager> ().currentTurnOwner;

		//GameObject.Find ("NetworkManager").GetComponent<photonNetworkManager> ().stopTimer ();
    }

	/// <summary>
	/// Starts the turn.
	/// </summary>
	public void StartTurn(){
		CurrentPlayerNumber = GameObject.Find ("NetworkManager").GetComponent<photonNetworkManager> ().currentTurnOwner;
		if (Units.Select(u => u.PlayerNumber).Distinct().Count() == 1){
			return;
		}
		if (!boolLock) {
			CellGridState = new CellGridStateTurnChanging (this);
			//Units.FindAll(u => u.PlayerNumber.Equals(CurrentPlayerNumber)).ForEach(u => { u.OnTurnEnd(); });
			Units.FindAll (u => u.PlayerNumber.Equals (PhotonNetwork.player.ID)).ForEach (u => {
				u.OnTurnStart ();
			});
			Players.Find(p => p.PlayerNumber.Equals(CurrentPlayerNumber)).Play(this); 
			boolLock = true;
			//GameObject.Find ("NetworkManager").GetComponent<photonNetworkManager> ().startTimer ();
		}


		}

}
