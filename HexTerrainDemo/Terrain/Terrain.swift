//
//  Terrain.swift
//  HexTerrainDemo
//
//  Created by Peter Kos on 11/17/18.
//  Copyright © 2018 UW. All rights reserved.
//

import Foundation


struct Terrain {

	// All tile objects representing our terrain
	var data: [TerrainTile]

	// Each number maps to a TerrainType
	// E.g., 0 = none, 1 = grass, 2 = dirt
	// @TODO: Serialize into a smarter data structure
	init(withPattern pattern: [[UInt8]]) {

		self.data = [TerrainTile]()

		// Iterate through provided data
		for row in pattern {
			for val in row {
				self.data.append(TerrainTile(tileType: val, height: 1))
			}
		}

	}
}
