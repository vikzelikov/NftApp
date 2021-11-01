//
//  Extenstions.swift
//  NftApp
//
//  Created by Yegor on 02.07.2021.
//

import Foundation
import UIKit


extension UIButton {
    func applyButtonStyle() {
        self.titleLabel?.textColor = UIColor(named: "default")
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        self.tintColor = UIColor(named: "default")
    }
    
    // bounds and haptic effects
    func applyButtonEffects() {
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchDragExit), for: .touchDragExit)
    }
    
    @objc func touchDown(_ sender: UIButton) {
        zoomIn()
        
        HapticHelper.vibro(.light)
    }
    
    @objc func touchUpInside(_ sender: UIButton) {
        zoomOut()
        
        HapticHelper.vibro(.medium)
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
    
    func loadingIndicator(isShow: Bool, titleButton: String?) {
        let tag = 9876
        if isShow {
            self.isEnabled = false
            self.setTitle("", for: .normal)

            let indicator = UIActivityIndicatorView()
            let buttonHeight = self.bounds.size.height
            let buttonWidth = self.bounds.size.width
            indicator.center = CGPoint(x: buttonWidth/2, y: buttonHeight/2)
            indicator.color = UIColor(named: "gray")
            indicator.tag = tag
            self.addSubview(indicator)
            indicator.startAnimating()
        } else {
            if let indicator = self.viewWithTag(tag) as? UIActivityIndicatorView {
                self.isEnabled = true
                self.setTitle(titleButton, for: .normal)
                
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
        }
    }
}

extension UITextField {
    func applyTextFieldStyle() {
        self.backgroundColor = UIColor(named: "gray")
        self.tintColor = UIColor(named: "orange")
        self.textColor = UIColor(named: "black")
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.borderStyle = .none
        self.font = .systemFont(ofSize: 16)

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
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
                border.frame = CGRect(x: 0, y: 45, width: width, height: thickness)
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

class AccentButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
        self.titleLabel?.textColor = UIColor(named: "default")
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        self.tintColor = UIColor(named: "default")
    }

    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()

        l.colors = [
            UIColor(red: 1, green: 0.333, blue: 0, alpha: 1).cgColor,
            UIColor(red: 1, green: 0.733, blue: 0, alpha: 1).cgColor
        ]

        l.startPoint = CGPoint(x: 0, y: 0.5)
        l.endPoint = CGPoint(x: 1, y: 0.5)
        l.cornerRadius = 16
        l.frame = self.bounds
        layer.insertSublayer(l, at: 0)
        return l
    }()
    
}
