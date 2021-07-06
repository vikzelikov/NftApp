//
//  Extenstions.swift
//  Genies
//
//  Created by Yegor on 02.07.2021.
//

import Foundation
import UIKit

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}


extension CALayer {

    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, width: CGFloat) {

            let border = CALayer()

            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect(x: 0, y: 0, width: width, height: thickness)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect(x: 0, y: 29, width: width, height: thickness)
                break
            case UIRectEdge.left:
                border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.bounds.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect(x: width - thickness, y: 0, width: thickness, height: self.bounds.height)
                break
            default:
                break
            }

            border.backgroundColor = color.cgColor;

            self.addSublayer(border)
        }
}
