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
	let mapSizeX = 8
	let mapSizeY = 8

	init(fromTerrain terrain: Terrain) {
		self.terrain = terrain

		// Generates the vertices for a hex
		// @TODO: Extract, currently getting "self" error
		func generateVertices(centerX: Int, centerY: Int, withHexHeight height: Float) -> [SCNVector3] {
			var vertices = [SCNVector3]()

			for point in 0..<6 {

				let position = Offset(x: centerX, y: centerY)
				let worldPos = position.toCartesian()
				print("posx: \(position.x), posy: \(position.y)")
				print("worldposx: \(worldPos.x), worldposy: \(worldPos.y)")

				let vertexX = worldPos.x + TerrainStatics.SCALE_FACTOR * cos(Float(60 * point - 30) * (Float.pi / 180))
				let vertexY = worldPos.y + TerrainStatics.SCALE_FACTOR * sin(Float(60 * point - 30) * (Float.pi / 180))
//				print("x: \(vertexX) y: \(height), z: \(vertexY)")
				vertices.append(SCNVector3(vertexX, height, vertexY))
			}

			return vertices
		}

		// Array for all geometry elements rendered in AR
		// May need to be moved to the class (class var instead of local var)
		//	if ownership is not transferred to the SCNGeometry class
		var vertexData = [SCNVector3]()
		var elementData = [Int32]()

		// Indices affect the culling of each hexagon
		var indices: [Int32] = [
			// Bottom Triangles
			// Outer triangles
			2, 1, 0,
			4, 3, 2,
			0, 5, 4,
			// Inner/Center triangles
			4, 2, 0,
			// Top Triangles
			// Outer triangles
			8, 7, 6,
			10, 9, 8,
			6, 11, 10,
			// Inner/Center triangles
			10, 8, 6
		]
		
		// Indices for the vertical sides
		for i: Int32 in 0..<6 {
			indices.append(i)
			indices.append(i + 6)
			indices.append(i + 7)
			
			indices.append(i + 7)
			indices.append(i + 1)
			indices.append(i)
		}

		// Iterate over all tiles on the map
		for x in 0..<mapSizeX {
			for y in 0..<mapSizeY {
				// In functor: if i == 5, need to handle wrap around for integers
				// If i == 5, generate: 5, 11, 6; 6, 0, 5
				elementData.append(contentsOf: indices.map({ return ($0 + Int32(vertexData.count))}))
				vertexData.append(contentsOf: generateVertices(centerX: x, centerY: y, withHexHeight: 0.0))
				vertexData.append(contentsOf: generateVertices(centerX: x, centerY: y, withHexHeight: Float(x + y)))
			}
		}
		
		self.geometry = SCNGeometry(sources: [SCNGeometrySource(vertices: vertexData)],
									elements: [SCNGeometryElement(indices: elementData, primitiveType: .triangles)])
		self.geometry?.name = "Terrain"
		self.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.7)
		self.geometry?.firstMaterial?.isDoubleSided = true
	}


}
