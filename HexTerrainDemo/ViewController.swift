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


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configures our SceneKit scene
        sceneView.delegate = self
        sceneView.showsStatistics = true
		sceneView.debugOptions = [.showFeaturePoints, .showWireframe]


		// Add custrom anchor for text label
		// @TODO: Attach to plane
//		var transformMatrix = matrix_identity_float4x4
//		transformMatrix.columns.3.z = -0.2
//		let anchor = ARAnchor(transform: transformMatrix)
//
//		sceneView.session.add(anchor: anchor)


		NotificationCenter.default.post(name: "", object: nil, userInfo: <#T##[AnyHashable : Any]?#>)

		// SpriteKit text and scene
		let textLabel = SKLabelNode(text: "Hello, World!")
		textLabel.color = UIColor.purple
		textLabel.fontSize = 20
		textLabel.lineBreakMode = .byWordWrapping
		textLabel.horizontalAlignmentMode = .center
		textLabel.position = CGPoint(x: sceneView.frame.midX / 2, y: 15)

		// Background color box for text label
		let textNode = SKSpriteNode(color: .purple, size: CGSize(width: sceneView.frame.maxX, height: 80))
		textNode.color = textNode.color.withAlphaComponent(0.9)
		textNode.addChild(textLabel)

		let textScene = SKScene(size: CGSize(width: sceneView.frame.midX, height: sceneView.frame.midY))
		textScene.scaleMode = .aspectFill
		textScene.addChild(textNode)

		sceneView.overlaySKScene = textScene


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

	func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {

//		let label = SCNText(string: "Hello", extrusionDepth: 1.0)
//		label.font = UIFont(name: "Helvetica", size: 20)
//		label.containerFrame = CGRect(origin: .zero, size: CGSize(width: 200.0, height: 500.0))
//		let textNode = SCNNode(geometry: label)
//		textNode.scale = SCNVector3Make(0.2, 0.2, 0.2)
//		return textNode
//
		return SCNNode()

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




extension CGSize {

	static func /(lhs: CGSize, rhs: CGFloat) -> CGSize {
		return CGSize(width: lhs.width / rhs, height: lhs.height / rhs)
	}

}
