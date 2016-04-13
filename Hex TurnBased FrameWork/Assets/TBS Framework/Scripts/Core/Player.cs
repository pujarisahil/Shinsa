using UnityEngine;

public abstract class Player : MonoBehaviour
{
    public int PlayerNumber;  

	void Start(){
		PlayerNumber = GameObject.Find ("Players").transform.childCount;
		gameObject.transform.SetParent (GameObject.Find ("Players").transform);
	}

    /// <summary>
    /// Method is called every turn. Allows player to interact with his units.
    /// </summary>         
    public abstract void Play(CellGrid cellGrid);
}