//
//  BodySkeleton.swift
//  ARtful
//
//  Created by Zerowave on 4/13/24.
//

import Foundation
import RealityKit
import ARKit

class BodySkeleton: Entity {
    var joints: [String: Entity] = [:]
    var bones: [String: Entity] = [:]
    
    required init(for bodyAnchor: ARBodyAnchor) {
        super.init()
        
        // Creates joint entities for each joint in the body
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            var jointRadius: Float = 0.03
            var jointColor: UIColor = .green
            
            // Customize appearance of joints
            switch jointName {
            case "left_hand_joint":
                jointRadius *= 1
                jointColor = .green
                
            case _ where jointName.hasPrefix("left_hand"):
                jointRadius *= 0.3
                jointColor = .green
                
            case "right_hand_joint":
                jointRadius *= 1
                jointColor = .red
                
            case _ where jointName.hasPrefix("right_hand"):
                jointRadius *= 0.3
                jointColor = .red
                
            default:
                jointRadius = 0.03
                jointColor = UIColor(red: 0.85, green: 0.7, blue: 0.85, alpha: 1.0)
            }
            
            // Creates and store the jointEntitys
            let jointEntity = createJoint(radius: jointRadius, color: jointColor)
            joints[jointName] = jointEntity
            self.addChild(jointEntity)
        }
        
        // Creates boneEntitys
        for bone in Bones.allCases {
            guard let skeletonBone = createSkeletonBone(bone: bone, bodyAnchor: bodyAnchor)
            else { continue }
            
            let boneEntity = createBoneEntity(for: skeletonBone)
            bones[bone.name] = boneEntity
            self.addChild(boneEntity)
        }
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
    
    // Update the body skeleton
    func update(with bodyAnchor: ARBodyAnchor) {
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
        // Update the position of joints on the skeleton
        for jointName in ARSkeletonDefinition.defaultBody3D.jointNames {
            if let jointEntity = joints[jointName],
               let jointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: jointName)) {
                
                let jointEntityOffsetFromRoot = simd_make_float3(jointEntityTransform.columns.3)
                jointEntity.position = jointEntityOffsetFromRoot + rootPosition
                jointEntity.orientation = Transform(matrix: jointEntityTransform).rotation
            }
        }
        
        // Update the bone positions
        for bone in Bones.allCases {
            let boneName = bone.name
            
            guard let entity = bones[boneName],
                    let skeletonBone = createSkeletonBone(bone: bone, bodyAnchor: bodyAnchor)
            else { continue }
            
            entity.position = skeletonBone.centerPosition
            entity.look(at: skeletonBone.toJoint.position, from: skeletonBone.centerPosition, relativeTo: nil)
        }
    }
    
    // Helper to create a joint entity with a radius and color
    private func createJoint(radius: Float, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateSphere(radius: radius)
        let material = SimpleMaterial(color: color, roughness: 0.8, isMetallic: false)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }
    
    // Helper to create a bone between two joints
    private func createSkeletonBone(bone: Bones, bodyAnchor: ARBodyAnchor) -> SkeletonBone? {
        guard let fromJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bone.jointFromName)),
                let toJointEntityTransform = bodyAnchor.skeleton.modelTransform(for: ARSkeleton.JointName(rawValue: bone.jointToName))
        else { return nil }
        
        let rootPosition = simd_make_float3(bodyAnchor.transform.columns.3)
        
        let jointFromEntityOffsetFromRoot = simd_make_float3(fromJointEntityTransform.columns.3)
        
        let jointFromEntityPosition = jointFromEntityOffsetFromRoot + rootPosition
        
        let jointToEntityOffsetFromRoot = simd_make_float3(toJointEntityTransform.columns.3)
        
        let jointToEntityPosition = jointToEntityOffsetFromRoot + rootPosition
        
        let fromJoint = SkeletonJoint(name: bone.jointFromName, position: jointFromEntityPosition)
        let toJoint = SkeletonJoint(name: bone.jointFromName, position: jointToEntityPosition)
        return SkeletonBone(fromJoint: fromJoint, toJoint: toJoint)
    }
    
    // Helper to create the skeleton
    private func createBoneEntity(for skeletonBone: SkeletonBone, diameter: Float = 0.02, color: UIColor = .white) -> Entity {
        let mesh = MeshResource.generateBox(size: [diameter, diameter, skeletonBone.length], cornerRadius: diameter/2)
        let material = SimpleMaterial(color: color, roughness: 0.5, isMetallic: true)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        return entity
    }
}
