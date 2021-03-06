//
//  BottomSheetViewController.swift
//  NftApp
//
//  Created by Yegor on 17.07.2021.
//

import UIKit

class FilterSheetViewController: UIViewController {
    
    @IBOutlet weak var featuredLabel: UILabel!
    @IBOutlet weak var priceLowToHighLabel: UILabel!
    @IBOutlet weak var priceHighToLowLabel: UILabel!
    
    var hasSetPointOrigin = false
    var pointOrigin: CGPoint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction))
        view.addGestureRecognizer(panGesture)
        
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(actionTapped(_:)))
        featuredLabel?.isUserInteractionEnabled = true
        featuredLabel?.addGestureRecognizer(tapAction)
        
        let tapAction1 = UITapGestureRecognizer(target: self, action: #selector(actionTapped1(_:)))
        priceLowToHighLabel?.isUserInteractionEnabled = true
        priceLowToHighLabel?.addGestureRecognizer(tapAction1)
        
        let tapAction2 = UITapGestureRecognizer(target: self, action: #selector(actionTapped2(_:)))
        priceHighToLowLabel?.isUserInteractionEnabled = true
        priceHighToLowLabel?.addGestureRecognizer(tapAction2)
    }
    
    @objc func actionTapped(_ sender: UITapGestureRecognizer) {
        resetFilter()
        featuredLabel.textColor = UIColor(named: "orange")
    }
    
    @objc func actionTapped1(_ sender: UITapGestureRecognizer) {
        resetFilter()
        priceLowToHighLabel.textColor = UIColor(named: "orange")
    }
    
    @objc func actionTapped2(_ sender: UITapGestureRecognizer) {
        resetFilter()
        priceHighToLowLabel.textColor = UIColor(named: "orange")
    }
    
    private func resetFilter() {
        HapticHelper.vibro(.light)

        featuredLabel.textColor = UIColor(named: "black")
        priceLowToHighLabel.textColor = UIColor(named: "black")
        priceHighToLowLabel.textColor = UIColor(named: "black")
    }
    
    override func viewDidLayoutSubviews() {
        if !hasSetPointOrigin {
            hasSetPointOrigin = true
            pointOrigin = self.view.frame.origin
        }
    }
    
    @objc func panGestureRecognizerAction(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        
        // Not allowing the user to drag the view upward
        guard translation.y >= 0 else { return }
        
        // setting x as 0 because we don't want users to move the frame side ways!! Only want straight up or down
        view.frame.origin = CGPoint(x: 0, y: self.pointOrigin!.y + translation.y)
        
        if sender.state == .ended {
            let dragVelocity = sender.velocity(in: view)
            if dragVelocity.y >= 1300 {
                self.dismiss(animated: true, completion: nil)
            } else {
                // Set back to original position of the view controller
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin = self.pointOrigin ?? CGPoint(x: 0, y: 400)
                }
            }
        }
    }
}
