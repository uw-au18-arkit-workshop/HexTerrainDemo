//
//  Tile.swift
//  HexTerrainDemo
//
//  Created by Peter Kos on 11/17/18.
//  Copyright © 2018 UW. All rights reserved.
//

import Foundation


struct Tile {

	// Data for each tile
	var tileType: TileType
	var height: Double

}


// The various things a tile can be
enum TileType {
	case Grass
}

