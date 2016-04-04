using UnityEngine;
using System.Collections;
using System;

public class shinsaUnit : Unit
{
    public Color LeadingColor;
    public string UnitName;

    public override void Initialize() {
        base.Initialize();
        transform.position += new Vector3(0, 0, -1);
        GetComponent<SpriteRenderer>().color = LeadingColor;
		Cell.setIndex (PlayerNumber);
    }

    public override void MarkAsAttacking(Unit other)
    {
        throw new NotImplementedException();
    }

    public override void MarkAsDefending(Unit other)
    {
        throw new NotImplementedException();
    }

    public override void MarkAsDestroyed()
    {
		Debug.Log ("haha");
        //throw new NotImplementedException();
    }

    public override void MarkAsFinished()
    {
        //meObject.Find("CellGrid2").GetComponent<CellGrid>().EndTurn();
    }

    public override void MarkAsFriendly()
    {
        GetComponent<SpriteRenderer>().color = LeadingColor/* + new Color(0.8f, 1, 0.8f, 1f)*/;
    }

    public override void MarkAsReachableEnemy()
    {
        GetComponent<SpriteRenderer>().color = LeadingColor + Color.red;
    }

    public override void MarkAsSelected()
    {
        GetComponent<SpriteRenderer>().color = LeadingColor + Color.green;
        //Debug.Log("hahaha");
    }

    public override void UnMark()
    {
        GetComponent<SpriteRenderer>().color = LeadingColor;
    }
}
