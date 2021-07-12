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
        
        setupStyle()
        
        // disable back swipe
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    private func setupStyle() {
        if #available(iOS 13.4, *) {
            dateBirthPicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        
        nextButton.applyButtonStyle()
        nextButton.applyButtonEffects()
    }
    
    @IBAction func nextDidTap(_ sender: Any) {
        if isSelectedSex {
            nextButton.loadingIndicator(isShow: true, titleButton: nil)
            
            // CREATE ACCOUNT
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.showHome()
            }
        }
        
        isSelectedSex = true
        selectSexButtons.isHidden = false
        dateBirthPicker.isHidden = true
        titleLabel.text = "What do you identify as?"
    }
    
    @IBAction func maleButtonDidTap(_ sender: Any) {
        maleButton.backgroundColor = UIColor(named: "gray")
        femaleButton.backgroundColor = UIColor.black
    }
    
    @IBAction func femaleButtonDidTap(_ sender: Any) {
        femaleButton.backgroundColor = UIColor(named: "gray")
        maleButton.backgroundColor = UIColor.black
    }
    
    private func showHome() {
        let homeStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
        guard let homePage = homeStoryboard.instantiateViewController(withIdentifier: "TabBarViewController") as? TabBarViewController else { return }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = homePage
    }
}
