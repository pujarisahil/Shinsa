using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class AssignUsername : MonoBehaviour {

	public Text username1;
	public Text rank1;
	public Text username2;
	public Text rank2;

	public void assignInfo(string username, string rank){
		if (photonNetworkManager.thisPlayerNumber == 1) {
			username1.text = username;
			rank1.text = rank;
		} else if(photonNetworkManager.thisPlayerNumber == 2) {
			username2.text = username;
			rank2.text = rank;
		}
	}
}
