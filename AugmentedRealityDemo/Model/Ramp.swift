//
//  Ramp.swift
//  AugmentedRealityDemo
//
//  Created by MacBook Pro on 8/28/18.
//  Copyright © 2018 Bassyouni. All rights reserved.
//

import Foundation
import SceneKit

class Ramp
{
    
    class func getRamp(forName rampName: String) -> SCNNode
    {
        switch rampName {
        case "pipe":
            return Ramp.getPipe()
        case "pyramid":
            return Ramp.getPyramid()
        case "quarter":
            return Ramp.getQuarter()
        default:
            return Ramp.getPipe()
        }
    }
    
    class func getPipe() -> SCNNode
    {
        let obj = SCNScene(named: "art.scnassets/pipe.dae")!
        let node = obj.rootNode.childNode(withName: "pipe", recursively: true)!
        let scale: Float = 0.0022
        node.scale = SCNVector3Make(scale, scale, scale)
        node.position = SCNVector3Make(-1, 0.7, -1)
        return node
    }
    
    class func getPyramid() -> SCNNode
    {
        let obj = SCNScene(named: "art.scnassets/pyramid.dae")!
        let node = obj.rootNode.childNode(withName: "pyramid", recursively: true)!
        let scale: Float = 0.0058
        node.scale = SCNVector3Make(scale, scale, scale)
        node.position = SCNVector3Make(-1, -0.45, -1)
        return node
    }
    
    class func getQuarter() -> SCNNode
    {
        let obj = SCNScene(named: "art.scnassets/quarter.dae")!
        let node = obj.rootNode.childNode(withName: "quarter", recursively: true)!
        let scale: Float = 0.0058
        node.scale = SCNVector3Make(scale, scale, scale)
        node.position = SCNVector3Make(-1, -2.2, -1)
        return node
    }
    
    class func startRotation(node: SCNNode)
    {
        let rotation = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0.01 * CGFloat.pi, z: 0, duration: 0.05))
        node.runAction(rotation)
    }
    
}
