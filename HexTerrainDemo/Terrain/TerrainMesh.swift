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

	// Mesh data for all terrain
	var terrain: Terrain
	var geometry: SCNGeometry? // @TODO: Subclass SCNGeometry to define our own mesh structure (hexagon)
	let mapSizeX = 16
	let mapSizeY = 16
	let scaleFactor: Float = 0.01

	init(fromTerrain terrain: Terrain) {
		self.terrain = terrain

		// Generates the vertices for a hex
		// @TODO: Extract, currently getting "self" error
		func generateVertices(centerX: Float, centerY: Float, withHexHeight height: Float) -> [SCNVector3] {
			var vertices = [SCNVector3]()

			for point in 0..<6 {
				let vertexX = centerX * cos(Float(60 * point - 30))
				let vertexY = centerY * sin(Float(60 * point - 30))
				print("x: \(vertexX) y: \(vertexY)")
				vertices.append(SCNVector3(vertexX * scaleFactor, height, vertexY * scaleFactor))
			}

			return vertices
		}

		// Array for all geometry elements rendered in AR
		// May need to be moved to the class (class var instead of local var)
		//	if ownership is not transferred to the SCNGeometry class
		var vertices = [SCNGeometrySource]()
		var elements = [SCNGeometryElement]()

		let indices = [
			// Outer triangles
			0, 1, 2,
			2, 3, 4,
			4, 5, 6,
			// Inner/Center triangles
			0, 2, 4
		]

		// Iterate over all tiles on the map
		for x in 0..<mapSizeX {
			for y in 0..<mapSizeY {
				let vertexData = generateVertices(centerX: Float(x), centerY: Float(y), withHexHeight: 0.1)
				print("vertexData: \(vertexData)")
				vertices.append(SCNGeometrySource(vertices: vertexData))
				elements.append(SCNGeometryElement(indices: indices, primitiveType: .triangles))
			}
		}

		self.geometry = SCNGeometry(sources: vertices, elements: elements)
		self.geometry?.name = "Terrain"
		self.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.7)
		self.geometry?.firstMaterial?.isDoubleSided = true

//		self.geometry = SCNBox(width: 0.4, height: 0.4, length: 0.4, chamferRadius: 0)
	}


}
