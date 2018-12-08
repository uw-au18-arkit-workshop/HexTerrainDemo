//
//  TerrainMesh.swift
//  HexTerrainDemo
//
//  Created by Peter Kos on 11/17/18.
//  Copyright © 2018 UW. All rights reserved.
//

import Foundation
import SceneKit


func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
	return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}



class TerrainMesh {

	// Mesh data for all terrain
	var terrain: Terrain
	var geometry: SCNGeometry?
	let mapSizeX = 8
	let mapSizeY = 8
	

	init(fromTerrain terrain: Terrain) {
		self.terrain = terrain

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
		// Precondition: Type must be Int32
		for i: Int32 in 0..<5 {
			indices.append(i)
			indices.append(i + 6)
			indices.append(i + 7)
			
			indices.append(i + 7)
			indices.append(i + 1)
			indices.append(i)
		}

		// We need to handle wrapping around our indices
		// when we finish drawing the side of the 3d hexagon
		// If i == 5, we need to replace: 5, 11, 12; 12, 6, 5 to
		//                                5, 11, 6 ; 6,  0, 5
		indices.append(contentsOf: [5, 11, 6, 6, 0, 5])

		// This lets us stopwatch our vertex generation time for... reasons.
		let startTime = CFAbsoluteTimeGetCurrent()

		let bottomLeft = Offset(x: 0, y: 0).toCartesian()
		let topRight = Offset(x: mapSizeX - 1, y: mapSizeY - 1).toCartesian()

		let mapWidth = topRight.x - bottomLeft.x
		let mapHeight = topRight.y -  bottomLeft.y

		let vertexOffset = SCNVector3(mapWidth / 2.0, 0.0, mapHeight / 2.0)

		// Iterate over all vertices and offset them by the correct amount
		for x in 0..<mapSizeX {
			for z in 0..<mapSizeY {

				// Offset each indice to the correct hexagon
				elementData.append(contentsOf: indices.map { num -> Int32 in
					return num + Int32(vertexData.count)
				})

				// Generate top and bottom vertices
				vertexData.append(contentsOf: generateVertices(centerX: x, centerZ: z, withHexHeight: 0.1))
				vertexData.append(contentsOf: generateVertices(centerX: x, centerZ: z, withHexHeight: 0.5))
			}
		}

		vertexData = vertexData.map{ $0 - vertexOffset }

		// Finish stopwatch
		let endTime = CFAbsoluteTimeGetCurrent()
		print("Vertex generation time: \(endTime - startTime)")

		// Assign geometry to class attribute
		self.geometry = SCNGeometry(sources: [SCNGeometrySource(vertices: vertexData)],
		                            elements: [SCNGeometryElement(indices: elementData, primitiveType: .triangles)])


		// Set basic texture parameters to see the darn things
		// (See lighting effects in ViewController for corresponding effect
		self.geometry?.firstMaterial?.diffuse.contents = UIColor.red
		self.geometry?.firstMaterial?.transparency = 0.5
		self.geometry?.firstMaterial?.transparencyMode = .dualLayer
		self.geometry?.firstMaterial?.isDoubleSided = true
		self.geometry?.name = "Terrain"
	}


	/// Generates vertices for all hexagons
	///
	/// - Parameters:
	///   - centerX: Center of hexagon to draw from, in x plane
	///   - centerZ: Center of hexagon to draw from, in z plane
	///   - height: Height of each hexagon (thickness) in y plane
	/// - Returns: Array of vertices, each a vector of <x, y, z> coordinates
	private func generateVertices(centerX: Int, centerZ: Int, withHexHeight height: Float) -> [SCNVector3] {

		var vertices = [SCNVector3]()

		// Generates hexagon verticies using this image
		// as reference: https://imgur.com/Jcn53n2
		for point in 0..<6 {

			let worldPos = Offset(x: centerX, y: centerZ).toCartesian()
			let spacing: Float = 0.8 // Gaps between tiles
			let x = cos(Float(60 * point - 30) * (Float.pi / 180))
			let z = sin(Float(60 * point - 30) * (Float.pi / 180))

			let vertexX = worldPos.x + TerrainStatics.SCALE_FACTOR * x * spacing
			let vertexZ = worldPos.y + TerrainStatics.SCALE_FACTOR * z * spacing
			vertices.append(SCNVector3(vertexX, height, vertexZ))
		}

		return vertices
	}

}
