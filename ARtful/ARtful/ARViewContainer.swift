//
//  ARViewContainer.swift
//  ARtful
//
//  Created by Zerowave on 4/13/24.
//

import SwiftUI
import ARKit
import RealityKit
import SceneKit

private var bodySkeleton: BodySkeleton?
private let bodySkeletonAnchor = AnchorEntity()

struct ARViewContainer: UIViewRepresentable {
    typealias UIViewType = ARView

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        
        arView.setupForBodyTracking()
        arView.scene.addAnchor(bodySkeletonAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        // Leave empty
    }
}

extension ARView {
    func pauseSession() {
        self.session.pause()
    }
    
    func resumeSession() {
        let configuration = ARBodyTrackingConfiguration()
        self.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
}

extension ARView: ARSessionDelegate {
    func setupForBodyTracking() {
        let configuration = ARBodyTrackingConfiguration()
        self.session.run(configuration)
        
        self.session.delegate =  self
    }
    
    public func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        
        for anchor in anchors {
            if let bodyAnchor = anchor as? ARBodyAnchor {
                if let skeleton = bodySkeleton {
                    skeleton.update(with: bodyAnchor)
                } else {
                    bodySkeleton = BodySkeleton(for: bodyAnchor)
                    bodySkeletonAnchor.addChild(bodySkeleton!)
                }

                // Get the right hand position
                if let rightWristTransform = bodyAnchor.skeleton.modelTransform(for: .rightHand) {
                    let rightPosition = simd_make_float3(rightWristTransform.columns.3)
                    let rightBodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
                    let rightGlobalPosition = rightBodyPosition + rightPosition

                    // Get the left hand position
                    if let leftWristTransform = bodyAnchor.skeleton.modelTransform(for: .leftHand) {
                        let leftPosition = simd_make_float3(leftWristTransform.columns.3)
                        let leftBodyPosition = simd_make_float3(bodyAnchor.transform.columns.3)
                        let leftGlobalPosition = leftBodyPosition + leftPosition

                        // Define the Y-coordinate threshold for the right hand
                        let yThreshold: Float = 0.55

                        // Check if the right hand is below the threshold to allow drawing
                        if rightGlobalPosition.y < yThreshold {
                            // Create a sphere and place it at the left wrist position
                            let sphere = MeshResource.generateSphere(radius: 0.015)
                            let material = SimpleMaterial(color: .blue, isMetallic: false)
                            let sphereEntity = ModelEntity(mesh: sphere, materials: [material])
                            sphereEntity.position = leftGlobalPosition
                            bodySkeletonAnchor.addChild(sphereEntity)
                        }
                    }
                }
            }
        }
    }
}
