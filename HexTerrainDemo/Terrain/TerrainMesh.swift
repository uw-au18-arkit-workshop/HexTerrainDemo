//
//  TerrainMesh.swift
//  HexTerrainDemo
//
//  Created by Peter Kos on 11/17/18.
//  Copyright © 2018 UW. All rights reserved.
//

import Foundation
import SceneKit

class TerrainMesh {

	// Mesh data for a chunk of terrain
	var terrain: Terrain
	var geometry: SCNGeometry // @TODO: Subclass SCNGeometry to define our own mesh structure (hexagon)

	init(fromTerrain terrain: Terrain, geometry: SCNGeometry) {
		self.terrain = terrain
		self.geometry = geometry
	}


}
