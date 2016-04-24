using UnityEngine;
using System.Collections;
using Photon;
using UnityEngine.UI;

public class photonNetworkManager : Photon.PunBehaviour {

	public CellGrid cellgrid;
	public GameObject player;
	// Use this for initialization
	public Transform Units;
	public int currentTurnOwner = 1;
	public static int thisPlayerNumber = 1000;

	public Text connectionStatusText;

	public GameObject TurnStatus;
	public Text yourTurnText;
	public Text enemyTurnText;
	public Image indicationLight;

	public GameObject winPanel;
	public GameObject lossPanel;

	void Start () {
		PhotonNetwork.ConnectUsingSettings ("0.1");
	}

	IEnumerator Joined(){
		yield return new WaitForSeconds (1.5f);
		connectionStatusText.enabled = false;
		TurnStatus.SetActive (true);
	}


	void OnJoinedRoom(){
		GameObject player = PhotonNetwork.Instantiate ("HumanPlayer", Vector3.zero, Quaternion.identity, 0);
		thisPlayerNumber = PhotonNetwork.player.ID;
		Debug.Log ("this player unit tag is " + player.GetComponent<Player> ().unitSetName);
		GetComponent<PhotonView> ().RPC ("setUnitPlayerNum", PhotonTargets.AllBuffered, player.GetComponent<Player> ().unitSetName, PhotonNetwork.player.ID);
		StartCoroutine (Joined ());


		//Application.ExternalEval ("GetUsername");
	}

	[PunRPC]
	public void WinAndLoss(int loserIndex){
		Time.timeScale = 0f;
		if (loserIndex == thisPlayerNumber) {
			lossPanel.SetActive (true);
		} else {
			winPanel.SetActive (true);
		}

		PhotonNetwork.Disconnect ();
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

		connectionStatusText.text = PhotonNetwork.connectionStateDetailed.ToString ();
		Debug.LogWarning ("Local ownership is " + PhotonNetwork.player.ID);
		Debug.LogWarning ("That remote ownership is" + PhotonNetwork.otherPlayers[0].ID);
		Debug.LogWarning ("playernumber is " + PhotonNetwork.playerList.Length);
		Debug.Log ("this number is" + thisPlayerNumber);

		if (currentTurnOwner == thisPlayerNumber) {
			cellgrid.StartTurn ();
			enemyTurnText.enabled = false;
			yourTurnText.enabled = true;
			if (indicationLight.color.a <= 0.5f) {
				indicationLight.color = Color.Lerp (indicationLight.color,new Color(indicationLight.color.a,indicationLight.color.b,indicationLight.color.g,0.5f),2.5f*Time.deltaTime);
			}
		} else if(thisPlayerNumber != 1000){
			enemyTurnText.enabled = true;
			yourTurnText.enabled = false;
			if (indicationLight.color.a > 0f) {
				indicationLight.color = Color.Lerp (indicationLight.color,new Color(indicationLight.color.a,indicationLight.color.b,indicationLight.color.g,0f),2.5f*Time.deltaTime);
			}
		}
	}
}
