//
//  HomeViewController.swift
//  Genies
//
//  Created by Yegor on 08.06.2021.
//

import UIKit
import Foundation
import SceneKit
import ModelIO
import SceneKit.ModelIO

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var viewer = Insert3DViewer()
        viewer.width = 380
        viewer.height = Int(UIScreen.main.bounds.size.height * 0.9) - viewer.height / 2
        viewer.x = Int(UIScreen.main.bounds.size.width * 0.5) - viewer.width / 2
        viewer.y = 100
        var model = Insert3DModel()
        model.mesh = "man.obj"
        model.material = "text1.jpg"

        setupScene(viewerSetup: viewer, modelSetup: model)
    }
    
    var mSceneView: SCNView? = nil
    
    public func setupScene(viewerSetup: Insert3DViewer, modelSetup: Insert3DModel) {
        
        let scene = SCNScene()
        
        guard let url = Bundle.main.url(forAuxiliaryExecutable: modelSetup.mesh) else {
            fatalError("Failed to find model file.")
        }
        
        // Model Load
        let asset = MDLAsset(url:url)
        guard let object = asset.object(at: 0) as? MDLMesh else {
            fatalError("Failed to get mesh from asset.")
        }
        
        // Create a material from the texture
        let scatteringFunction = MDLScatteringFunction()
        let material = MDLMaterial(name: "baseMaterial", scatteringFunction: scatteringFunction)
        let meshUrl = Bundle.main.url(forResource: modelSetup.material, withExtension: "")
        material.setProperty(MDLMaterialProperty(name: modelSetup.material, semantic: .baseColor, url: meshUrl))
        
        // Material load
        for  submesh in object.submeshes!  {
            if let submesh = submesh as? MDLSubmesh {
                submesh.material = material
            }
        }
        
        // Wrap the ModelIO object in a SceneKit object
        let modelNode = SCNNode(mdlObject: object)
//        modelNode.camera = SCNCamera()
//        modelNode.camera?.fieldOfView = 2
        

        scene.rootNode.addChildNode(modelNode)
        
        let sceneView = SCNView(frame: CGRect(x: viewerSetup.x, y: viewerSetup.y, width: viewerSetup.width, height: viewerSetup.height))
        mSceneView = sceneView
        
        for reco in sceneView.gestureRecognizers! {
            if let panReco = reco as? UIPanGestureRecognizer {
                panReco.maximumNumberOfTouches = 1
            }
        }
        sceneView.isMultipleTouchEnabled = false
        sceneView.isExclusiveTouch = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
     
        view.addSubview(sceneView)
        sceneView.scene = scene
        
        
        //set up scene
        sceneView.autoenablesDefaultLighting = false
        sceneView.allowsCameraControl = true
        sceneView.defaultCameraController.maximumVerticalAngle = 15
        sceneView.defaultCameraController.minimumVerticalAngle = 15
        sceneView.cameraControlConfiguration.rotationSensitivity = 0.4
        sceneView.scene = scene
        //scnView.backgroundColor = UIColor.clear
        scene.background.contents = viewerSetup.background
    }
    
    
    @objc func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        let cameraNode: SCNNode? = mSceneView?.pointOfView
        print(cameraNode?.rotation ?? "There is no camera set to the view")
    }
    
//    func disableMultitouchInSubview(of view: UIView) {
//       let subviews = view.subviews
//       if subviews.count == 0 { return }
//       for subview in subviews {
//        print("**")
//            subview.isExclusiveTouch = true
//            subview.isMultipleTouchEnabled = false
//            disableMultitouchInSubview(of: subview)
//       }
//    }

}

public struct Insert3DViewer {
    public var width: Int
    public var height: Int
    public var x: Int
    public var y: Int
    public var background: NSObject
    public init() {
        width = 200;
        height = 200;
        x = 0;
        y = 0;
        background = UIColor.white;
    }
}

public struct Insert3DModel {
    public var mesh: String
    public var material: String
    public init() {
        mesh = "";
        material = "";
    }
}
