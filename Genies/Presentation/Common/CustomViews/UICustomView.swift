//
//  UICustomView.swift
//  Genies
//
//  Created by Yegor on 15.07.2021.
//

import Foundation
import UIKit

class UICustomView: UIView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            HapticHelper.buttonVibro(.light)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            HapticHelper.buttonVibro(.medium)
        }
    }
    
}
