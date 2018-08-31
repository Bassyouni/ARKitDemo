//
//  RampPickerVC.swift
//  AugmentedRealityDemo
//
//  Created by MacBook Pro on 8/28/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import UIKit
import SceneKit

class RampPickerVC: UIViewController
{
    
    var sceneView: SCNView!
    var size: CGSize!
    weak var rampPlacerVC: RampPlacerVC?
    
    // specify the pop over size
    init(size: CGSize)
    {
        super.init(nibName: nil, bundle: nil)
        self.size = size
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.frame = CGRect(origin: CGPoint.zero, size: size)
        sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height ))
        view.insertSubview(sceneView, at: 0)
        
        //for dislaying popovers and others
        preferredContentSize = size
        
//        self.view.layer.borderColor = UIColor.white.cgColor
//        self.view.layer.borderWidth = 3.0
        
        let scene = SCNScene(named: "art.scnassets/ramps.scn")!
        sceneView.scene = scene
        
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        scene.rootNode.camera = camera
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        let pipe = Ramp.getPipe()
        Ramp.startRotation(node: pipe)
        scene.rootNode.addChildNode(pipe)
        
        let pyramid = Ramp.getPyramid()
        Ramp.startRotation(node: pyramid)
        scene.rootNode.addChildNode(pyramid)
        
        let quarter = Ramp.getQuarter()
        Ramp.startRotation(node: quarter)
        scene.rootNode.addChildNode(quarter)
        
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer)
    {
        let location = gesture.location(in: sceneView)
        let hitResult = sceneView.hitTest(location, options: [:])
        
        if hitResult.count > 0
        {
            let node = hitResult[0].node
            rampPlacerVC?.onRampSelected(node.name!)
            dismiss(animated: true, completion: nil)
        }
    }


}













