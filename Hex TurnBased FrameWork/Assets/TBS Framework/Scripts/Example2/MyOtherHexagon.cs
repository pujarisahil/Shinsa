using System;
using System.Collections.Generic;
using UnityEngine;

public class MyOtherHexagon : Hexagon
{
    public GroundType GroundType;
    public bool IsSkyTaken;//Indicates if a flying unit is occupying the cell.

    public void Start()
    {
        SetColor(new Color(1,1,1,0));
    }

    public override void MarkAsReachable()
    {
		//Debug.Log ("reachable");
        SetColor(new Color(1f, 1f, 1f, 0.5f));
    }

	/// <summary>
	///  Method of highlighting a path(deprecated)
	/// </summary>
    public override void MarkAsPath()
    {
		Debug.Log ("MarkAsPath method is deprecated");
        //SetColor(new Color(0,1,1,1));
    }
    public override void MarkAsHighlighted()
    {
        SetColor(new Color(1f,1f,1f,0.5f));
    }
    public override void UnMark()
    {
        SetColor(new Color(1,1,1,0));
    }

    private void SetColor(Color color)
    {
        var highlighter = transform.FindChild("Highlighter");
        var spriteRenderer = highlighter.GetComponent<SpriteRenderer>();
        if (spriteRenderer != null)
        {
            spriteRenderer.color = color;
        }
        foreach (Transform child in highlighter.transform)
        {
			var childColor = new Color(color.r,color.g,color.b,color.a);
            spriteRenderer = child.GetComponent<SpriteRenderer>();
            if (spriteRenderer == null) continue;

            child.GetComponent<SpriteRenderer>().color = childColor;
        }
    }

    public override Vector3 GetCellDimensions()
    {
        var ret = GetComponent<SpriteRenderer>().bounds.size;
        return ret*0.98f;
    }
}

public enum GroundType
{
};