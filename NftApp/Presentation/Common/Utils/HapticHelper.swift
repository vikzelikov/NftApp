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
    
}
