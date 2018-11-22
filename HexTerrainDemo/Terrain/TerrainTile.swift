//
//  TerrainTile.swift
//  HexTerrainDemo
//
//  Created by Zach Wilson on 11/22/18.
//  Copyright © 2018 UW. All rights reserved.
//

import Foundation

// Data for each tile
struct TerrainTile {
	// Type of the tile
	var tileType: TileType
	// Height of the tile
	// Tile heights are discrete, so a floating point type does not need
	//	to be used for the tile height
	var height: Int
}
