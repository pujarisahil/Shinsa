using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class AssignUsername : MonoBehaviour {

	public Text username1;
	public Text username2;

	public void assignInfo(string username){
		if (photonNetworkManager.thisPlayerNumber == 1) {
			username1.text = username;
		} else if(photonNetworkManager.thisPlayerNumber == 2) {
			username2.text = username;
		}
	}
}
