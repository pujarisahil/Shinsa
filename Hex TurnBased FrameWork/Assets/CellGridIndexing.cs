using UnityEngine;
using System.Collections;

public class CellGridIndexing : MonoBehaviour {


	// this script is used to index each cell at the beginning of the game
	// the purpose of this is to help serialization of Unit functions in two clients. 
	void Start () {
		for (int i = 0; i < transform.childCount; i++) {
			transform.GetChild (i).gameObject.name = "Hexagon" + i.ToString();
		}
	}

}
