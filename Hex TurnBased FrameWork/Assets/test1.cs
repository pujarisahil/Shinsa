using UnityEngine;
using System.Collections;
using Photon;
using UnityEngine.UI;

public class test1 : Photon.MonoBehaviour {

	public GameObject thisobject;
	private Vector3 readInPos;
	public Text showText;

	void Start(){

		thisobject = gameObject;
	}

	void Update(){

		if (Input.GetMouseButtonDown (0)) {
			transformIt ();
		}

		if (!thisobject.GetPhotonView ().isMine) {
			thisobject.transform.position = readInPos;
		}

	}

	void pressedButton(){
		int i;
		if (thisobject.GetPhotonView ().ownerId == 1)
			i = 0;
		else
			i = 1;

			thisobject.GetPhotonView ().TransferOwnership (i);
			gameObject.GetPhotonView ().TransferOwnership (i);
			//showText.gameObject.GetPhotonView ().TransferOwnership (i);
	}
		

	void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info){
		if (stream.isWriting) {
			stream.SendNext (thisobject.transform.position);
		} else {
			readInPos = (Vector3)stream.ReceiveNext ();
			Debug.Log ("read the pos" + readInPos);
		}
	}

	public void transformIt(){

		Debug.Log ("it passed");
		thisobject.transform.position = new Vector3 (thisobject.transform.position.x, thisobject.transform.position.y - 1.0f, thisobject.transform.position.z);
		//pressedButton ();
	}
}
