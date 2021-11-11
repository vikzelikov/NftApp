//
//  AddFundsViewController.swift
//  NftApp
//
//  Created by Yegor on 01.08.2021.
//

import UIKit

class AddFundsViewController: UIViewController {
    
    var viewModel: AddFundsViewModel?

    @IBOutlet weak var nextButton: AccentButton!
    @IBOutlet weak var firstItem: UIView!
    @IBOutlet weak var secondItem: UIView!
    @IBOutlet weak var itemsStackView: UIStackView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = AddFundsViewModelImpl()
        
        bindData()

        setupStyle()
    }
    
    func setupStyle() {
        if #available(iOS 13.0, *) {
            loadingIndicator.style = .large
        } else {
            loadingIndicator.style = .gray
        }

        nextButton.applyButtonEffects()
        
        let firstItemDidTap = UITapGestureRecognizer(target: self, action: #selector(firstItemDidTap(_:)))
        firstItem?.addGestureRecognizer(firstItemDidTap)
        
        let secondItemDidTap = UITapGestureRecognizer(target: self, action: #selector(secondItemDidTap(_:)))
        secondItem?.addGestureRecognizer(secondItemDidTap)
    }
    
    func bindData() {
        viewModel?.products.bind {
            if !$0.isEmpty {
                self.itemsStackView.isHidden = false
                self.setSelected(selectedView: self.firstItem)
                self.viewModel?.productDidTap(index: 0)
            }
        }
        
        viewModel?.errorMessage.bind {
            guard let errorMessage = $0 else { return }
            self.showMessage(message: errorMessage)
        }
        
        viewModel?.isLoading.bind {
            print($0)
            $0 ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
        }
    }
    
    @objc func firstItemDidTap(_ sender: UITapGestureRecognizer) {
        setSelected(selectedView: firstItem)
        
        viewModel?.productDidTap(index: 0)
    }
    
    @objc func secondItemDidTap(_ sender: UITapGestureRecognizer) {
        setSelected(selectedView: secondItem)
        
        viewModel?.productDidTap(index: 1)
    }
    
    func setSelected(selectedView: UIView) {
        resetSelected()
        
        UIView.animate(withDuration: 0.2) {
            selectedView.transform = .identity
        }
        
        selectedView.alpha = 2
        
        selectedView.isUserInteractionEnabled = false
        
        HapticHelper.vibro(.light)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { HapticHelper.vibro(.heavy) }
        
        selectedView.layer.borderWidth = 2
        selectedView.layer.borderColor = UIColor(named: "orange")?.cgColor
    }
    
    func resetSelected() {
        UIView.animate(withDuration: 0.2) {
            self.firstItem?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        UIView.animate(withDuration: 0.2) {
            self.secondItem?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
        
        firstItem.isUserInteractionEnabled = true
        secondItem.isUserInteractionEnabled = true
        
        firstItem.alpha = 0.5
        secondItem.alpha = 0.5
        
        firstItem.layer.borderWidth = 0
        firstItem.layer.borderColor = UIColor.clear.cgColor
        
        secondItem.layer.borderWidth = 0
        secondItem.layer.borderColor = UIColor.clear.cgColor
    }
        
    @IBAction func continueDidTap(_ sender: Any) {
        nextButton.loadingIndicator(isShow: true, titleButton: nil)

        viewModel?.nextDidTap { result in
            if result {
                self.showMessage(message: NSLocalizedString("Successful purchase", comment: ""), isHaptic: false)
            }
            
            self.nextButton.loadingIndicator(isShow: false, titleButton: "CONTINUE")
        }
    }
    
    @IBAction func dismissDidTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
