using UnityEngine;
using System.Collections;
using Photon;

public class photonNetworkManager : Photon.PunBehaviour {

	public CellGrid cellgrid;
	public GameObject player;
	// Use this for initialization
	public Transform Units;
	//public int[] IdCache;
	public int currentUnitsOwnshipID = 0;

	void Start () {
		PhotonNetwork.ConnectUsingSettings ("0.1");
		/*
		int i = Units.childCount - 1;
		for (; i >= 0; i--) {
			PhotonView.Get (Units.GetChild (i).gameObject).TransferOwnership (PhotonNetwork.player.ID);
		}
		*/
	}

	void OnGUI(){
		GUILayout.Label(PhotonNetwork.connectionStateDetailed.ToString());
	}
		

	public void transferOwnership(){
		
		int i = Units.childCount - 1;
		/*
		Debug.Log ("i " + i);
		if (currentUnitsOwnshipID == 0)
			currentUnitsOwnshipID = 1;
		else
			currentUnitsOwnshipID = 0;
		*/
		for (; i >= 0; i--) {
			PhotonView.Get (Units.GetChild (i).gameObject).TransferOwnership (PhotonNetwork.otherPlayers[0].ID);
		}
	}

	void OnJoinedRoom(){
		Debug.Log (Resources.Load("HumanPlayer"));
		GameObject player = PhotonNetwork.Instantiate ("HumanPlayer", Vector3.zero, Quaternion.identity, 0);
		//GameObject plane = PhotonNetwork.Instantiate ("Plane", Vector3.zero, Quaternion.identity, 0);
		//float random = Random.Range (-22f, -17f);
		//GameObject plane = PhotonNetwork.Instantiate("plane", new Vector3(-21f, random, 84f), Quaternion.Euler(-89f, -180f, -180f), 0);
		//GameObject button = PhotonNetwork.Instantiate ("Button", );
	}


	public override void OnJoinedLobby ()
	{
		PhotonNetwork.JoinRandomRoom ();
	}

	void OnPhotonRandomJoinFailed(){
		Debug.Log ("we create a room");
		PhotonNetwork.CreateRoom (null);
	}

	void Update(){
		if (player.transform.childCount == 2) {
			cellgrid.enabled = true;
		}

		Debug.LogWarning ("Local ownership is " + PhotonNetwork.player.ID);
		Debug.LogWarning ("playernumber is " + PhotonNetwork.playerList.Length);
	}
}
