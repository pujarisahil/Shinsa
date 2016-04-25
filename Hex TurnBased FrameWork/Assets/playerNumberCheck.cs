using UnityEngine;
using System.Collections;

/// <summary>
/// Check the number of players. This script help start the game and end the game(when there is a player quits).
/// </summary>

public class playerNumberCheck : MonoBehaviour {

	public CellGrid grid;
	public GameObject surrenderButton;
	public GameObject yourOpponentQuitsText;

	private bool lok = false;
	public bool gameStarted = false;

	// Update is called once per frame
	void Update () {
		if (transform.childCount > 1 && !lok) {
			surrenderButton.SetActive (true);
			grid.enabled = true;
			lok = false;
			gameStarted = true;
			GameObject.Find ("NetworkManager").GetComponent<photonNetworkManager> ().closeRoom ();
		}
		if (gameStarted && transform.childCount == 1) {
			//one player quit, announce winner
			yourOpponentQuitsText.SetActive (true);
			GameObject.Find("NetworkManager").GetComponent<PhotonView>().RPC("WinAndLoss", PhotonTargets.All, (transform.GetChild(0).GetComponent<HumanPlayer>().PlayerNumber == 1) ? 2 : 1);
		}
	}
}
