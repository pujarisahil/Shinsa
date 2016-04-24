using UnityEngine;
using System.Collections;

public class Surrender : MonoBehaviour {

	public GameObject surrenderPanel;

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
	}


}
