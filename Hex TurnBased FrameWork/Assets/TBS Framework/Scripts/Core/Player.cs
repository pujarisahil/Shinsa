using UnityEngine;
using Photon;

public abstract class Player : UnityEngine.MonoBehaviour
{
    public int PlayerNumber;
	public string unitSetName;

	void Awake(){
		PlayerNumber = GetComponent<PhotonView> ().ownerId;
		if (PlayerNumber > 1) {
			this.unitSetName = "UnitSet1"; 
		} else {
			this.unitSetName = "UnitSet0";
		}
		//this.unitSetName = "UnitSet" + GameObject.Find ("Players").transform.childCount.ToString();
		gameObject.transform.SetParent (GameObject.Find ("Players").transform);

	}

    /// <summary>
    /// Method is called every turn. Allows player to interact with his units.
    /// </summary>         
    public abstract void Play(CellGrid cellGrid);
}