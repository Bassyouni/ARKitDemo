//
//  RampPlacerVC.swift
//  AugmentedRealityDemo
//
//  Created by MacBook Pro on 8/28/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerVC: UIViewController, ARSCNViewDelegate {

    //MARK:- IBOutlets
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var controlsStackView: UIStackView!
    @IBOutlet weak var rotateBtn: UIButton!
    @IBOutlet weak var downBtn: UIButton!
    @IBOutlet weak var upBtn: UIButton!
    
    //MARK:- variables
    var selectedRampName: String?
    var rampsStack = Stack<SCNNode>()
    
    //MARK:- view's Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let longGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        let longGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        let longGesture3 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        
        longGesture1.minimumPressDuration = 0.1
        longGesture2.minimumPressDuration = 0.1
        longGesture3.minimumPressDuration = 0.1
        
        rotateBtn.addGestureRecognizer(longGesture1)
        upBtn.addGestureRecognizer(longGesture2)
        downBtn.addGestureRecognizer(longGesture3)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error)
    {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession)
    {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession)
    {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    //MARK:- IBActions
    @IBAction func rampBtnPressed(_ sender: UIButton)
    {
        // PopOver
        let rampPickerVC = RampPickerVC(size: CGSize(width: 250.0, height: 500))
        rampPickerVC.rampPlacerVC = self
        rampPickerVC.modalPresentationStyle = .popover
        rampPickerVC.popoverPresentationController?.delegate = self
        rampPickerVC.popoverPresentationController?.sourceView = sender
        rampPickerVC.popoverPresentationController?.sourceRect = sender.bounds
        present(rampPickerVC, animated: true, completion: nil)
    
    }
    
    @IBAction func onRemovePressed(_ sender: Any) {
        
        if let ramp = rampsStack.peek()
        {
            ramp.removeFromParentNode()
            rampsStack.pop()
        }
    }
    
    
    //MARK:- methods
    func onRampSelected(_ rampName: String)
    {
        selectedRampName = rampName
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        
        guard let hitFeature = results.last else { return }
        
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPostion = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        placeRamp(position: hitPostion)
    }
    
    func placeRamp(position: SCNVector3)
    {
        if let rampName = selectedRampName
        {
            controlsStackView.isHidden = false
            let ramp = Ramp.getRamp(forName: rampName)
            rampsStack.push(value: ramp)
            ramp.position = position
            ramp.scale = SCNVector3Make(0.01, 0.01, 0.01)
            sceneView.scene.rootNode.addChildNode(ramp)
        }
        
    }
    
    @objc func onLongPress(_ gesture: UILongPressGestureRecognizer)
    {
        if let ramp = rampsStack.peek()
        {
            if gesture.state == .ended
            {
                ramp.removeAllActions()
            }
            else if gesture.state == .began
            {
                let duration: TimeInterval = 0.1
                
                if gesture.view === rotateBtn
                {
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat.pi * 0.08, z: 0, duration: duration))
                    ramp.runAction(rotate)
                }
                else if gesture.view === upBtn
                {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: duration))
                    ramp.runAction(move)
                }
                else if gesture.view === downBtn
                {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: duration))
                    ramp.runAction(move)
                }
            }
        }
    }
    
    
}


//MARK: - PopOver Delegete
extension RampPlacerVC: UIPopoverPresentationControllerDelegate
{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}











