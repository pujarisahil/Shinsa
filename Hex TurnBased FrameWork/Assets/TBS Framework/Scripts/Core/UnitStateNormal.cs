using UnityEngine;

public class UnitStateNormal : UnitState
{
    public UnitStateNormal(Unit unit) : base(unit)
    {       
    }

    public override void Apply()
    {
        _unit.UnMark();
		Debug.LogWarning ("apply delection");
    }

    public override void MakeTransition(UnitState state)
    {
        state.Apply();
        _unit.UnitState = state;
    }
}

