//
//  Extenstions.swift
//  Genies
//
//  Created by Yegor on 02.07.2021.
//

import Foundation
import UIKit

extension UIView {
    
}


extension UIButton {
    func applyButtonStyle() {
        self.backgroundColor = ColorHelper.hexStringToUIColor(hex: "f0b235")
        self.layer.cornerRadius = 12
        self.titleLabel?.textColor = UIColor.black
        self.tintColor = UIColor.black
    }
    
    func applyButtonEffects() {
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
    }
    
    @objc func touchDown(_ sender: UIButton) {
        zoomIn()
        
        HapticHelper.buttonVibro(.light)
    }
    
    @objc func touchUpInside(_ sender: UIButton) {
        zoomOut()
        
        HapticHelper.buttonVibro(.medium)
    }
    
    @objc func touchDragExit(_ sender: UIButton) {
        zoomOut()
    }
    
    private func zoomIn() {
        UIView.animate(withDuration: 0.1,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: { _ in })
    }
    
    private func zoomOut() {
        UIView.animate(withDuration: 0.1,
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.transform = CGAffineTransform.identity
                }
            })
    }
}



//extension CALayer {
//
//    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, width: CGFloat) {
//
//            let border = CALayer()
//
//            switch edge {
//            case UIRectEdge.top:
//                border.frame = CGRect(x: 0, y: 0, width: width, height: thickness)
//                break
//            case UIRectEdge.bottom:
//                border.frame = CGRect(x: 0, y: 28, width: width, height: thickness)
//                break
//            case UIRectEdge.left:
//                border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.bounds.height)
//                break
//            case UIRectEdge.right:
//                border.frame = CGRect(x: width - thickness, y: 0, width: thickness, height: self.bounds.height)
//                break
//            default:
//                break
//            }
//
//            border.backgroundColor = color.cgColor;
//
//            self.addSublayer(border)
//        }
//}
