//
//  PersonalDataViewController.swift
//  NftApp
//
//  Created by Yegor on 09.07.2021.
//

import UIKit

class PersonalViewController: UIViewController {
    
    var viewModel: SignupViewModel?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var selectSexButtons: UIStackView!
    @IBOutlet weak var dateBirthPicker: UIDatePicker!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    private var isMale: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        
        setupStyle()
    }
    
    private func setupStyle() {
        if #available(iOS 13.4, *) {
            dateBirthPicker.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        
        nextButton.applyButtonStyle()
        nextButton.applyButtonEffects()
    }
    
    @IBAction func nextDidTap(_ sender: Any) {
        if isMale != nil {
            let birthDate = self.dateBirthPicker?.date.timeIntervalSince1970
            
            viewModel?.updatePersonalData(isMale: isMale, birthDate: birthDate)
        }
        
        selectSexButtons.isHidden = false
        dateBirthPicker.isHidden = true
        titleLabel.text = "What do you identify as?"
    }
    
    func bindData() {
        viewModel?.isLoading.observe(on: self) { [weak self] isLoading in
            isLoading ? self?.nextButton.loadingIndicator(isShow: true, titleButton: nil)
            : self?.nextButton.loadingIndicator(isShow: false, titleButton: "NEXT")
        }
        
        viewModel?.isSuccess.observe(on: self) { [weak self] isSuccess in
            if isSuccess { self?.showHomeView() }
        }
    }
    
    @IBAction func maleButtonDidTap(_ sender: Any) {
        isMale = true
        
        maleButton.backgroundColor = UIColor(named: "gray")
        femaleButton.backgroundColor = UIColor.black
    }
    
    @IBAction func femaleButtonDidTap(_ sender: Any) {
        isMale = false
        
        femaleButton.backgroundColor = UIColor(named: "gray")
        maleButton.backgroundColor = UIColor.black
    }
    
    private func showHomeView() {
        let homeStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
        guard
            let homePage = homeStoryboard
                .instantiateViewController(withIdentifier: "TabBarViewController")
                as? TabBarViewController
        else {
            return
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.rootViewController = homePage
    }
}
