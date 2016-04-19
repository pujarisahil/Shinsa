using UnityEngine;
using System.Collections;

public class playerNumberCheck : MonoBehaviour {

	public CellGrid grid;

	private bool lok = false;
	// Update is called once per frame
	void Update () {
		if (transform.childCount > 1 && !lok) {
			//don't use tranform.getChild()
			//starting doing set up here

			grid.enabled = true;
			lok = false;
		}
	}
}
