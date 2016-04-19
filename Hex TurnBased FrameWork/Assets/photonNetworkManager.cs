using UnityEngine;
using System.Collections;
using Photon;

public class photonNetworkManager : Photon.PunBehaviour {

	public CellGrid cellgrid;
	public GameObject player;
	// Use this for initialization
	public Transform Units;
	public int currentTurnOwner = 1;
	public static int thisPlayerNumber = 1000;

	void Start () {
		PhotonNetwork.ConnectUsingSettings ("0.1");
	}

	void OnGUI(){
		GUILayout.Label(PhotonNetwork.connectionStateDetailed.ToString());
	}
		
	void OnJoinedRoom(){
		GameObject player = PhotonNetwork.Instantiate ("HumanPlayer", Vector3.zero, Quaternion.identity, 0);
		thisPlayerNumber = PhotonNetwork.player.ID;
		Debug.Log ("this player unit tag is "+ player.GetComponent<Player>().unitSetName);
		GetComponent<PhotonView>().RPC ("setUnitPlayerNum", PhotonTargets.AllBuffered, player.GetComponent<Player>().unitSetName, PhotonNetwork.player.ID);
	}

	[PunRPC]
	public void changeTurnOnFly(){
		if (currentTurnOwner == 1)
			currentTurnOwner = 2;
		else if (currentTurnOwner == 2)
			currentTurnOwner = 1;
	}

	void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info){
		if (stream.isWriting) {
			stream.SendNext (currentTurnOwner);
		} else {
			currentTurnOwner = (int)stream.ReceiveNext ();
		}
	}
		

	[PunRPC]
	public void setUnitPlayerNum(string index, int id){
		Debug.Log ("Tag is" + index);

		foreach (GameObject a in GameObject.FindGameObjectsWithTag(index)) {
			//a.GetComponent<PhotonView>().RPC("setNumber", PhotonTargets.All, id);
			Debug.Log("runing it");
			a.GetComponent<shinsaUnit>().setNumber(id);
		}

	}

	public override void OnJoinedLobby ()
	{
		PhotonNetwork.JoinRandomRoom ();
	}

	void OnPhotonRandomJoinFailed(){
		Debug.Log ("we create a room");
		PhotonNetwork.CreateRoom (null, new RoomOptions(){maxPlayers = 2}, null);
	}

	void Update(){
		Debug.LogWarning ("Local ownership is " + PhotonNetwork.player.ID);
		Debug.LogWarning ("That remote ownership is" + PhotonNetwork.otherPlayers[0].ID);
		Debug.LogWarning ("playernumber is " + PhotonNetwork.playerList.Length);
		Debug.Log ("this number is" + thisPlayerNumber);

		if (currentTurnOwner == thisPlayerNumber) {
			cellgrid.StartTurn ();
		}
	}
}
