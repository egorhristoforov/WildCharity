//
//  ARSessionViewController.swift
//  WildCharity
//
//  Created by Egor on 28/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ARSessionViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var arSceneView: ARSCNView!
    private var startingPosition = SCNVector3(0, 0, 0)
    private var modelsCount: Int!
    private var models: [SCNNode] = []
    public var wildPoints: [WildPoint] = []
    
    private var areaRadius: CGFloat = 2 {
        didSet {
            startingPosition = SCNVector3(0, 0, -areaRadius)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let configuration = ARWorldTrackingConfiguration()
        
        arSceneView.session.run(configuration)
        
        modelsCount = wildPoints.count
        
        //TODO: Добавить новые модели животных
        for i in 0..<modelsCount {
            let modelNode = createModel(animal: "Panda")
            modelNode.position = getPositionForModel(withIndex: i)
            models.append(modelNode)
            arSceneView.scene.rootNode.addChildNode(modelNode)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arSceneView.session.pause()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arSceneView.delegate = self
        arSceneView.showsStatistics = false
        
        let scene = SCNScene()
        arSceneView.scene = scene
        
//        for i in 0..<modelsCount {
//            let modelNode = createModel(animal: "Panda")
//            modelNode.position = getPositionForModel(withIndex: i)
//            models.append(modelNode)
//            arSceneView.scene.rootNode.addChildNode(modelNode)
//        }
        
    }
    
    private func createModel(animal: String) -> SCNNode {
        let modelScene = SCNScene(named: "ARModels.scnassets/PandaWild.DAE")!
        let node = SCNNode()
        for child in modelScene.rootNode.childNodes {
            node.addChildNode(child)
        }
        node.scale = SCNVector3(0.001, 0.001, 0.001)
        
        return node
    }
    
    private func getPositionForModel(withIndex index: Int) -> SCNVector3 {
        if index == 0 {
            return startingPosition
        }
        
        let l = 2 * CGFloat.pi * CGFloat(index) / CGFloat(modelsCount) - CGFloat.pi / 2
        var x: CGFloat = 0
        var z: CGFloat = 0
        if l == CGFloat.pi / 2 {
            x = 0
            z = areaRadius
        } else if l < CGFloat.pi / 2{
            x = sqrt(pow(areaRadius, 2) / (1 + pow(tan(l), 2)))
            z = tan(l) * x
        } else {
            x = -sqrt(pow(areaRadius, 2) / (1 + pow(tan(l), 2)))
            z = tan(l) * x
        }
        
        return SCNVector3(x, 0, z)
    }
    
}
