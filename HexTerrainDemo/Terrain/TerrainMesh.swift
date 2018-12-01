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
	let mapSizeX = 2
	let mapSizeY = 2
	let scaleFactor: Float = 0.1

	init(fromTerrain terrain: Terrain) {
		self.terrain = terrain

		// Generates the vertices for a hex
		// @TODO: Extract, currently getting "self" error
		func generateVertices(centerX: Float, centerY: Float, withHexHeight height: Float) -> [SCNVector3] {
			var vertices = [SCNVector3]()

			for point in 0..<6 {
				let vertexX = centerX * cos(Float(60 * point - 30) * (Float.pi / 180))
				let vertexY = centerY * sin(Float(60 * point - 30) * (Float.pi / 180))
				print("x: \(vertexX * scaleFactor) y: \(height), z: \(vertexY * scaleFactor)")
				vertices.append(SCNVector3(vertexX * scaleFactor, height, vertexY * scaleFactor))
			}

			return vertices
		}

		// Array for all geometry elements rendered in AR
		// May need to be moved to the class (class var instead of local var)
		//	if ownership is not transferred to the SCNGeometry class
		var vertices = SCNGeometrySource()
		var elements = SCNGeometryElement()

		// Indices affect the culling of each hexagon
		let indices: [Int32] = [
//			// Outer triangles
			2, 1, 0,
			4, 3, 2,
			0, 5, 4,
			// Inner/Center triangles
			4, 2, 0
		]

		// Iterate over all tiles on the map
		for x in 0..<mapSizeX {
			for y in 0..<mapSizeY {
				let vertexData = generateVertices(centerX: Float(x), centerY: Float(y), withHexHeight: 0.0)
				print("vertexData: \(vertexData)")
				vertices = SCNGeometrySource(vertices: vertexData)
				elements = SCNGeometryElement(indices: indices, primitiveType: .triangles)
			}
		}

		self.geometry = SCNGeometry(sources: [vertices], elements: [elements])
		self.geometry?.name = "Terrain"
		self.geometry?.firstMaterial?.diffuse.contents = UIColor.red.withAlphaComponent(0.7)
		self.geometry?.firstMaterial?.isDoubleSided = true


		// THANKS STACKOVERFLOW
//		let hisVertices = [
////			SCNVector3(x: 5, y: 4, z: 0),
////			SCNVector3(x: -5 , y: 4, z: 0),
////			SCNVector3(x: -5, y: -5, z: 0),
////			SCNVector3(x: 5, y: -5, z: 0)
////			SCNVector3(4, 0, 4),
////			SCNVector3(-4, 0, 4),
////			SCNVector3(-4, 0, -4),
////			SCNVector3(4, 0, -4),
//		]
//
//		let allPrimitives: [Int32] = [0, 1, 2, 0, 2, 3]
//		let vertexSource = SCNGeometrySource(vertices: hisVertices)
//		let element = SCNGeometryElement(indices: allPrimitives, primitiveType: .triangles)
//		self.geometry = SCNGeometry(sources: [vertexSource], elements: [element])
//		self.geometry?.firstMaterial?.diffuse.contents = UIColor.red
//		self.geometry?.firstMaterial?.isDoubleSided = true
//


//		self.geometry = SCNBox(width: 0.4, height: 0.4, length: 0.4, chamferRadius: 0)
	}


}
