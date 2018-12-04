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

	var tileType: TileType // Type of the tile
	var height: Int // Tile heights are discrete, no need for Double

	// By default, tiles will be Grass
	init(tileType: TileType = .Grass, height: Int) {
		self.tileType = tileType
		self.height = height
	}


}


// The various things a tile can be
enum TileType: UInt8 {
	case None
	case Grass
	case Dirt
}
