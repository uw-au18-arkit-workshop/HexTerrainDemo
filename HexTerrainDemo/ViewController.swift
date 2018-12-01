//
//  ViewController.swift
//  HexTerrainDemo
//
//  Created by Peter Kos on 11/16/18.
//  Copyright © 2018 UW. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

	@IBOutlet var sceneView: ARSCNView!
	var terrainNode = SCNNode()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Configures our SceneKit scene
		sceneView.delegate = self
		sceneView.showsStatistics = true
		sceneView.debugOptions = [.showFeaturePoints, .showWireframe]

	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Create a session configuration
		let configuration = ARWorldTrackingConfiguration()
		configuration.planeDetection = .horizontal

		// Run the view's session
		sceneView.session.run(configuration)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		// Pause the view's session when view dissapears
		sceneView.session.pause()
	}

	// MARK: - ARSCNViewDelegate

	func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {

		// @FIXME: Remove "return" to allow processing of other types of nodes
		guard anchor is ARPlaneAnchor else {
			print("Found anchor, but not right one.")
			return
		}

		// Throw text where it thinks the plane is
		let textGeometry = SCNText(string: "Iss a plaane!", extrusionDepth: 3)
		textGeometry.font = UIFont(name: "Futura", size: 75)

		// Add text node and scale down to not be 1293867 meters tall
		let textNode = SCNNode(geometry: textGeometry)
		textNode.simdScale = float3(0.0005)

		// Why not some plane geometry too
		let planeGeometry = ARSCNPlaneGeometry(device: self.sceneView.device!)

		guard planeGeometry != nil else {
			fatalError("Unable to create plane geometry")
		}

		// Add material to make it visible
		planeGeometry?.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.5)

		// Adds initial plane daata to the blank ARSCNPlaneGeometry
		// @TODO: Move this to didUpate method
		planeGeometry?.update(from: (anchor as! ARPlaneAnchor).geometry)

		// Plane wrapper node
		let planeGeometryNode = SCNNode(geometry: planeGeometry!)




		// --- Terrain Node ---
		let terrain = Terrain(withPattern: [[1]])!
		print(terrain.data)
		let terrainMesh = TerrainMesh(fromTerrain: terrain)

		print(terrainMesh.geometry?.description)
		self.terrainNode = SCNNode(geometry: terrainMesh.geometry)
		self.terrainNode.scale = SCNVector3(0.01, 0.01, 0.01)

		// Finally, add everything to the scene
		node.addChildNode(textNode)
		node.addChildNode(planeGeometryNode)
		node.addChildNode(terrainNode)
		print("Added all to node!")

	}

	func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

		// @FIXME: Remove "return" to allow processing of other types of nodes
		guard anchor is ARPlaneAnchor else {
			print("Found anchor, but not the right one.")
			return
		}

		// Grab our plane node
		// @FIXME: Remove "return" to allow processing of other types of nodes
		let potentialPlaneNodes = node.childNodes.filter({ $0.geometry as? ARSCNPlaneGeometry != nil })
		guard let planeNode = potentialPlaneNodes.first else {
			print("No plane nodes updated this cycle.")
			return
		}

		guard let planeGeometry = planeNode.geometry as? ARSCNPlaneGeometry else {
			print("Unable to convert updated geometry to valid ARSCNPlaneGeometry")
			return
		}

		// Update the geometry!
		planeGeometry.update(from: (anchor as! ARPlaneAnchor).geometry)

		node.addChildNode(self.terrainNode)

	}

	func session(_ session: ARSession, didFailWithError error: Error) {
		// Present an error message to the user
	}

	func sessionWasInterrupted(_ session: ARSession) {
		// Inform the user that the session has been interrupted, for example, by presenting an overlay
	}

	func sessionInterruptionEnded(_ session: ARSession) {
		// Reset tracking and/or remove existing anchors if consistent tracking is required
	}
}
