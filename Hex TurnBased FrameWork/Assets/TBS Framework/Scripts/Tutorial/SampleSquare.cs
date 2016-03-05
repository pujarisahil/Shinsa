﻿using System;
using System.Collections.Generic;
using UnityEngine;

class SampleSquare : Square
{
    public override Vector3 GetCellDimensions()
    {
        return GetComponent<Renderer>().bounds.size;
    }

    public override void MarkAsHighlighted()
    {
        GetComponent<Renderer>().material.color = new Color(0.75f, 0.75f, 0.75f); ;
    }

    public override void MarkAsPath()
    {
        GetComponent<Renderer>().material.color = Color.green;
    }

    public override void MarkAsReachable()
    {
        GetComponent<Renderer>().material.color = Color.yellow;
    }

    public override void UnMark()
    {
        GetComponent<Renderer>().material.color = Color.white;
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
    public override List<Cell> Get3LineNeighbours(List<Cell> cells)
    {
        throw new NotImplementedException();
    }
}

