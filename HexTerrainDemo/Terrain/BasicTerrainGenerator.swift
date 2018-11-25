//
//  File.swift
//  HexTerrainDemo
//
//  Created by Peter Kos on 11/16/18.
//  Copyright © 2018 UW. All rights reserved.
//

import Foundation
import SceneKit
import ARKit

class BasicTerrainGenerator: TerrainGenerator {

	// Creates a Terrain object with every tile set to the same type & height,
	// using data provided by the TerrainMesh.

	// Genrates terrain using the specified mesh pattern
	static func generateTerrain(withMesh mesh: TerrainMesh) -> SCNNode {

		let rootTerrainNode = SCNNode()

		// @FIXME: Read from mesh.totalGeometry instead
		rootTerrainNode.addChildNode(SCNNode(geometry: mesh.geometry))

		return rootTerrainNode

	}

}
