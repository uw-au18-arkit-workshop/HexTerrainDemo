//
//  TerrainMesh.swift
//  HexTerrainDemo
//
//  Created by Peter Kos on 11/17/18.
//  Copyright © 2018 UW. All rights reserved.
//

import Foundation



class TerrainMesh {

	// Mesh data for a chunk of terrain
	var terrain: Terrain

	init(fromTerrain terrain: Terrain) {
		self.terrain = terrain
	}


	// @TODO: Might be easier to wrap this functionality into Terrain as a computed property, and have TerrainMesh as a protocol ("interface")

}
