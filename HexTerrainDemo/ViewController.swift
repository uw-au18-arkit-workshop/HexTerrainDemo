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
import os.log
import SceneKit.ModelIO

class ViewController: UIViewController, ARSCNViewDelegate {

	@IBOutlet var sceneView: ARSCNView!
	var terrainNode = SCNNode()
	var meepleNode = SCNNode()

	override func viewDidLoad() {
		super.viewDidLoad()

		// Configures our SceneKit scene
		sceneView.delegate = self
		sceneView.showsStatistics = true
//		sceneView.debugOptions = [.showFeaturePoints, .showWorldOrigin, .showLightExtents, .showLightInfluences]
		sceneView.automaticallyUpdatesLighting = false // Disable default lighting from SceneKit
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		// Create a session configuration
		let configuration = ARWorldTrackingConfiguration()
		configuration.planeDetection = .horizontal    // We only want to detect things like tables
		configuration.isLightEstimationEnabled = true // Enable dynamic light estimation from ARKit

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

		// Shows the geometry of the detected plane
		var planeGeometry: ARSCNPlaneGeometry?
		if let viewDevice = self.sceneView.device {
			planeGeometry = ARSCNPlaneGeometry(device: viewDevice)
		} else {

			// If we're unable to find a device on our scene, create a default one
			let defaultDevice = MTLCreateSystemDefaultDevice()

			guard defaultDevice != nil else {
				fatalError("Unable to find default Metal device.")
			}

			planeGeometry = ARSCNPlaneGeometry(device: defaultDevice!)
		}

		guard planeGeometry != nil else {
			fatalError("Unable to create plane geometry")
		}

		// Add material to make it visible
		planeGeometry?.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.2)

		// Adds initial plane daata to the blank ARSCNPlaneGeometry
		// @TODO: Move this to didUpate method
		planeGeometry?.update(from: (anchor as! ARPlaneAnchor).geometry)

		// Plane wrapper node
		let planeGeometryNode = SCNNode(geometry: planeGeometry!)



		// --- Terrain Node ---
		let terrain = Terrain(withPattern: [[1]])!
		let terrainMesh = TerrainMesh(fromTerrain: terrain)
		self.terrainNode = SCNNode(geometry: terrainMesh.geometry)
		self.terrainNode.scale = SCNVector3(0.05, 0.05, 0.05)


		// Lighting for terrain
		let spotlight = SCNLight()
		spotlight.type = .spot
		spotlight.spotInnerAngle = 45
		spotlight.spotOuterAngle = 160

		// Create light node and position it
		// @TODO: Fix when map is centered
		// (Tip: Use view debug: SceneKit to try out pos/rot params!)
		let lightNode = SCNNode()
		lightNode.light = spotlight
		lightNode.position = SCNVector3(0.17, 0.237, 0)
		lightNode.eulerAngles = SCNVector3Make(-((2 * .pi) / 3), 0, 0)

		// --- Meeple Node ---
		// Load the .STL file
//		guard let meepleUrl = Bundle.main.url(forResource: "Meeple", withExtension: "stl") else {
//			fatalError("Failed to find model file.")
//		}


//		let meepleURL = Bundle.main.url(forResource: "Meeple", withExtension: "stl")
//		print(meepleURL)
//		let meepleAsset = MDLAsset(url: meepleURL!)
//
//		guard let meepleObject = meepleAsset.object(at: 0) as? MDLMesh else {
//			fatalError("Failed to get mesh from asset.")
//		}
//
//		// Wrap the ModelIO object in a SceneKit object
//		let meeepleGeometry = SCNGeometry(mdlMesh: meepleObject)
//		self.meepleNode = SCNNode(geometry: meeepleGeometry)

		// Finally, add everything to the scene
		node.addChildNode(textNode)
		node.addChildNode(planeGeometryNode)
		node.addChildNode(terrainNode)
		node.addChildNode(lightNode)
//		node.addChildNode(meepleNode)
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

	func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {

		let lightEstimate = self.sceneView.session.currentFrame?.lightEstimate

		guard lightEstimate != nil else {
			return
		}

//		os_log("Light esimate: %f", lightEstimate!.ambientIntensity)

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
