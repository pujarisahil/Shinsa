using UnityEngine;
using System.Collections;

public class printCell : MonoBehaviour {

	// testing script
	void Update () {
		Debug.Log (GetComponent<HighPerceptor> ().Cell.gameObject.transform.position);
	}
}
