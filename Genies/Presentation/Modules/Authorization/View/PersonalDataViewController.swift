//
//  PersonalDataViewController.swift
//  Genies
//
//  Created by Yegor on 09.07.2021.
//

import UIKit

class PersonalDataViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var selectSexButtons: UIStackView!
    @IBOutlet weak var dateBirthPicker: UIDatePicker!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    private var isSelectedSex: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.4, *) {
            dateBirthPicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        
        nextButton.applyButtonStyle()
    }
    
    @IBAction func nextDidTap(_ sender: Any) {
        if isSelectedSex {
//            dismiss(animated: true, completion: nil)
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true)
        }
        
        isSelectedSex = true
        selectSexButtons.isHidden = false
        dateBirthPicker.isHidden = true
        titleLabel.text = "What do you identify as?"
        
        UIView.animate(withDuration: 0.1,
            animations: {
                self.nextButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            },
            completion: { _ in
                UIView.animate(withDuration: 0.1) {
                    self.nextButton.transform = CGAffineTransform.identity
                }
            })
        HapticHelper.buttonVibro(.light)
    }
    
    @IBAction func maleButtonDidTap(_ sender: Any) {
        maleButton.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        femaleButton.backgroundColor = UIColor.white
    }
    
    @IBAction func femaleButtonDidTap(_ sender: Any) {
        femaleButton.backgroundColor = UIColor.black.withAlphaComponent(0.05)
        maleButton.backgroundColor = UIColor.white
    }
    
}
