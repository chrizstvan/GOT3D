//
//  ViewController.swift
//  GOT3D
//
//  Created by Christian Stevanus on 01/03/19.
//  Copyright © 2019 Christian Stevanus. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        sceneView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        // Image to track
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Classic Cards", bundle: Bundle.main) {
            
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 2
            
            print("image successfully added")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        
        let node = SCNNode()
        
        // making image as anchor of 3D obj
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width,
                                 height: imageAnchor.referenceImage.physicalSize.height)
            
            // make the plane transparent
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.5)
            
            let planeNode = SCNNode(geometry: plane)
            planeNode.eulerAngles.x = -.pi / 2
            
            node.addChildNode(planeNode)
            
            // Set 3d object to display
            if imageAnchor.referenceImage.name == "jack-card" {
                
                if let pokeScene = SCNScene(named: "art.scnassets/pikachu.scn") {
                    
                    // placing obj to world space using node
                    if let pokeNode = pokeScene.rootNode.childNodes.first {
                        //fixing rotating issue
                        pokeNode.eulerAngles.x = .pi / 2
                        //show pokemon model in plane
                        planeNode.addChildNode(pokeNode)
                    }
                }
            }
            
            if imageAnchor.referenceImage.name == "king-card" {
                
                if let pokeScene = SCNScene(named: "art.scnassets/oddish.scn") {
                    
                    // placing obj to world space using node
                    if let pokeNode = pokeScene.rootNode.childNodes.first {
                        //fixing rotating issue
                        pokeNode.eulerAngles.x = .pi / 2
                        //show pokemon model in plane
                        planeNode.addChildNode(pokeNode)
                    }
                }
            }
            
        }
        
        return node
    }
}
