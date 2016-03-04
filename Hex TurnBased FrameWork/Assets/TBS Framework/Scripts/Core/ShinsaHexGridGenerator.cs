using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Generates rectangular shaped grid of hexagons.
/// </summary>
[ExecuteInEditMode()]
class ShinsaHexGridGenerator : ICellGridGenerator
{
    public GameObject HexagonPrefab;
    public int Height;
    public int Width;

    public override List<Cell> GenerateGrid()
    {
        HexGridType hexGridType = Width % 2 == 0 ? HexGridType.even_q : HexGridType.odd_q;
        List<Cell> hexagons = new List<Cell>();

        //Shinsa implementation special
        //Set up a boolean value to check if the generation procedure reaches the last row.
        //if it reaches the last row, it will generate one hexagon cell then skip the next one, in order to create a correct shinsa board. 
        bool flicker = false;

		Color domColor = Color.red;
		Color secColor = Color.yellow;

        if (HexagonPrefab.GetComponent<Hexagon>() == null)
        {
            Debug.LogError("Invalid hexagon prefab provided");
            return hexagons;
        }

        for (int i = 0; i < Height; i++)
        {
            if (i == Height - 1)
            {
                //reach the last row, activate the flicker boolean
                flicker = true;
            }

            for (int j = 0; j < Width; j++)
            {
                if (i != Height - 1)
                {
                    //normal generation procedure
                    GameObject hexagon = Instantiate(HexagonPrefab);
                    var hexSize = hexagon.GetComponent<Cell>().GetCellDimensions();

                    hexagon.transform.position = new Vector3((j * hexSize.x * 0.75f), (i * hexSize.y) + (j % 2 == 0 ? 0 : hexSize.y * 0.5f));
                    hexagon.GetComponent<Hexagon>().OffsetCoord = new Vector2(Width - j - 1, Height - i - 1);
                    hexagon.GetComponent<Hexagon>().HexGridType = hexGridType;
                    hexagon.GetComponent<Hexagon>().MovementCost = 1;

					if (j % 2 == 0) {
						hexagon.GetComponent<SpriteRenderer> ().color = domColor;
					} else {
						hexagon.GetComponent<SpriteRenderer> ().color = secColor;
					}
                    hexagons.Add(hexagon.GetComponent<Cell>());
                    hexagon.transform.parent = CellsParent;
                }
                else {
                    if (flicker)
                    {
                        //last row generation procedure
                        GameObject hexagon = Instantiate(HexagonPrefab);
                        var hexSize = hexagon.GetComponent<Cell>().GetCellDimensions();

                        hexagon.transform.position = new Vector3((j * hexSize.x * 0.75f), (i * hexSize.y) + (j % 2 == 0 ? 0 : hexSize.y * 0.5f));
                        hexagon.GetComponent<Hexagon>().OffsetCoord = new Vector2(Width - j - 1, Height - i - 1);
                        hexagon.GetComponent<Hexagon>().HexGridType = hexGridType;
                        hexagon.GetComponent<Hexagon>().MovementCost = 1;

						if (j % 2 == 0) {
							hexagon.GetComponent<SpriteRenderer> ().color = domColor;
						} else {
							hexagon.GetComponent<SpriteRenderer> ().color = secColor;
						}

                        hexagons.Add(hexagon.GetComponent<Cell>());
                        hexagon.transform.parent = CellsParent;
                    }
                    flicker = !flicker;
                }
            }
			Color temp = domColor;
			domColor = colorChanger (domColor, secColor);
			secColor = temp;
        }
		//CellsParent.transform.rotation = new Quaternion (0f,0f,-45f,0f);
		//CellsParent.transform.rotation.Set (0f,0f,-45f,0f);
        return hexagons;
    }



    Color colorChanger(Color dominColor, Color secColor)
    {
		if ((dominColor == Color.green && secColor == Color.red) || (dominColor == Color.red && secColor == Color.green)) {
			return Color.yellow;
		} else if ((dominColor == Color.green && secColor == Color.yellow) || (dominColor == Color.yellow && secColor == Color.green)) {
			return Color.red;
		}else if((dominColor == Color.red && secColor == Color.yellow) || (dominColor == Color.yellow && secColor == Color.red)){
			return Color.green;
		}
			
		return Color.white;
    }
}