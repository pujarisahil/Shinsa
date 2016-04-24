using UnityEngine;
using System.Collections;

public class Surrender : MonoBehaviour {

	public GameObject surrenderPanel;
	public photonNetworkManager networkManager;

	void Start(){
		surrenderPanel.SetActive (false);
	}
	public void enablePanel(){
		surrenderPanel.SetActive (!surrenderPanel.activeInHierarchy);
	}
		
	/// <summary>
	/// Surrenders the game.
	/// </summary>
	public void surrenderIt(){
		//return null;
		Time.timeScale = 0f;
		networkManager.gameObject.GetComponent<PhotonView> ().RPC ("WinAndLoss", PhotonTargets.All, photonNetworkManager.thisPlayerNumber);
	}


}
