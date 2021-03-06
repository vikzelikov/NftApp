//
//  HapticHelper.swift
//  NftApp
//
//  Created by Yegor on 10.07.2021.
//

import Foundation
import UIKit

struct HapticHelper {
    
    static func vibro(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
    
    static func longHaptic() {
        HapticHelper.vibro(.light)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { HapticHelper.vibro(.heavy) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { HapticHelper.vibro(.light) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { HapticHelper.vibro(.heavy) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { HapticHelper.vibro(.light) }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { HapticHelper.vibro(.heavy) }
    }
    
}
