//
//  Bones.swift
//  ARtful
//
//  Created by Zerowave on 4/13/24.
//

import Foundation


enum Bones: CaseIterable {
    
    // Left Arm
    case leftShoulderToLeftArm
    case leftArmToLeftForearm
    case leftForearmToLeftHand
    
    //Right Arm
    case rightShoulderToRightArm
    case rightArmToRightForearm
    case rightForearmToRightHand
    
    // Shoulder
    case spine7ToLeftShoulder
    case spine7ToRightShoulder
    
    // Spine
    case neck1ToSpine7
    case spine7ToSpine6
    case spine6ToSpine5

    // Left Leg
    case hipsToLeftUpLeg
    case leftUpLegToLeftLeg
    case leftLegToLeftFoot
    
    // Right Leg
    case hipsToRightUpLeg
    case rightUpLegToRightLeg
    case rightLegToRightFoot

    
    var name: String {
        return "\(self.jointFromName)-\(self.jointToName)"
    }
    
    var jointFromName: String {
        switch self {
            
        // Left Arm
        case .leftShoulderToLeftArm:
            return "left_shoulder_1_joint"
        case .leftArmToLeftForearm:
            return "left_arm_joint"
        case .leftForearmToLeftHand:
            return "left_forearm_joint"
            
        // Right Arm
        case .rightShoulderToRightArm:
            return "right_shoulder_1_joint"
        case .rightArmToRightForearm:
            return "right_arm_joint"
        case .rightForearmToRightHand:
            return "right_forearm_joint"

        // Shoulder
        case .spine7ToLeftShoulder:
            return "spine_7_joint"
        case .spine7ToRightShoulder:
            return "spine_7_joint"

        // Spine
        case .neck1ToSpine7:
            return "neck_1_joint"
        case .spine7ToSpine6:
            return "spine_7_joint"
        case .spine6ToSpine5:
            return "spine_6_joint"
            
        // Left Leg
        case .hipsToLeftUpLeg:
            return "hips_joint"
        case .leftUpLegToLeftLeg:
            return "left_upLeg_joint"
        case .leftLegToLeftFoot:
            return "left_leg_joint"
            
        // Right Leg
        case .hipsToRightUpLeg:
            return "hips_joint"
        case .rightUpLegToRightLeg:
            return "right_upLeg_joint"
        case .rightLegToRightFoot:
            return "right_leg_joint"

        }
    }
    
    var jointToName: String {
        switch self {
        
        // Left Arm
        case .leftShoulderToLeftArm:
            return "left_arm_joint"
        case .leftArmToLeftForearm:
            return "left_forearm_joint"
        case .leftForearmToLeftHand:
            return "left_hand_joint"
        
        // Right Arm
        case .rightShoulderToRightArm:
            return "right_arm_joint"
        case .rightArmToRightForearm:
            return "right_forearm_joint"
        case .rightForearmToRightHand:
            return "right_hand_joint"

        // Shoulder
        case .spine7ToLeftShoulder:
            return "left_shoulder_1_joint"
        case .spine7ToRightShoulder:
            return "right_shoulder_1_joint"

        // Spine
        case .neck1ToSpine7:
            return "spine_7_joint"
        case .spine7ToSpine6:
            return "spine_6_joint"
        case .spine6ToSpine5:
            return "spine_5_joint"
            
        // Left Leg
        case .hipsToLeftUpLeg:
            return "left_upLeg_joint"
        case .leftUpLegToLeftLeg:
            return "left_leg_joint"
        case .leftLegToLeftFoot:
            return "left_foot_joint"
            
        // Right Leg
        case .hipsToRightUpLeg:
            return "right_upLeg_joint"
        case .rightUpLegToRightLeg:
            return "right_leg_joint"
        case .rightLegToRightFoot:
            return "right_foot_joint"

        }
    }
}
