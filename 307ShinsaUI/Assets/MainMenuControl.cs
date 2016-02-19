using UnityEngine;
using System.Collections;
using UnityEngine.UI;

public class MainMenuControl : MonoBehaviour {

    public GameObject GamePanel;
    public GameObject HowToPlayPanel;
    public GameObject SettingPanel;
    public GameObject CreditPanel;

    private Vector3 recordPos;
    private GameObject recordPanel;

    public void buttonListener(int buttonIndex)
    {
        if(buttonIndex == 0)
        {
            recordPos = GamePanel.GetComponent<RectTransform>().position;
            recordPanel = GamePanel;

            StartCoroutine(panelMoving(Vector3.zero, GamePanel));
        }
        else if(buttonIndex == 1)
        {
            recordPos = HowToPlayPanel.GetComponent<RectTransform>().position;
            recordPanel = HowToPlayPanel;
            StartCoroutine(panelMoving(Vector3.zero, HowToPlayPanel));
        }
        else if(buttonIndex == 2)
        {
            recordPos = SettingPanel.GetComponent<RectTransform>().position;
            recordPanel = SettingPanel;
            StartCoroutine(panelMoving(Vector3.zero, SettingPanel));
        }
        else if(buttonIndex == 3)
        {
            recordPos = CreditPanel.GetComponent<RectTransform>().position;
            recordPanel = CreditPanel;
            StartCoroutine(panelMoving(Vector3.zero, CreditPanel));
        }
        else if(buttonIndex == 4)
        {
            StartCoroutine(panelMoving(recordPos,recordPanel));
        }


    }

    IEnumerator panelMoving(Vector3 desiredPos, GameObject objectToMove)
    {
        float startTime = Time.time;
        while (Time.time < startTime + 0.8f)
        {
            objectToMove.GetComponent<RectTransform>().position = Vector3.Lerp(objectToMove.GetComponent<RectTransform>().position, desiredPos, 0.2f);
            yield return null;
        }
        objectToMove.GetComponent<RectTransform>().position = desiredPos;

    }



    // Use this for initialization
    void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
