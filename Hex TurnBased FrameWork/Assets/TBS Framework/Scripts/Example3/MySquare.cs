using System;
using System.Collections.Generic;
using UnityEngine;

public class MySquare : Square
{
    public void Start()
    {
        transform.FindChild("Highlighter").GetComponent<SpriteRenderer>().sortingOrder = 3;
    }

    public override Vector3 GetCellDimensions()
    {
        var ret = GetComponent<SpriteRenderer>().bounds.size;
        return ret*0.98f;
    }

    public override void MarkAsReachable()
    {
        SetColor(new Color(1,0.92f,0.16f,0.5f));
    }
    public override void MarkAsPath()
    {
        SetColor(new Color(0,1,0,0.5f));
    }
    public override void MarkAsHighlighted()
    {
        SetColor(new Color(0.8f,0.8f,0.8f,0.5f));
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
    }
    public override List<Cell> Get6LineNeighbours(List<Cell> cells)
    {
        throw new NotImplementedException();
    }
    public override List<Cell> Get1LineNeighbours(List<Cell> cells)
    {
        throw new NotImplementedException();
    }
    public override List<Cell> GetSameColorCrossNeighbours(List<Cell> cells)
    {
        throw new NotImplementedException();
    }
    public override List<Cell> GetFrontNeighbour(List<Cell> cells)
    {
        throw new NotImplementedException();
    }
}
