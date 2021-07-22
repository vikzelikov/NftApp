//
//  TabBarController.swift
//  Genies
//
//  Created by Yegor on 13.07.2021.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        
        self.delegate = self
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    func setupTabBar() {
        let shop = UIStoryboard(name: "Shop", bundle: nil)
        guard let firstVC = shop.instantiateViewController(withIdentifier: "ShopViewController") as? ShopViewController else { return }
        
        let avatar = UIStoryboard(name: "Home", bundle: nil)
        guard let secondVC = avatar.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else { return }
        
        let profile = UIStoryboard(name: "Settings", bundle: nil)
        guard let thirdVC = profile.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else { return }

        let tabBarList = [firstVC, secondVC, thirdVC]
        
        tabBar.isTranslucent = true
        tabBar.barTintColor = .black
        tabBar.tintColor = .white
        tabBar.backgroundColor = UIColor(named: "gray")
        tabBar.layer.backgroundColor = UIColor.clear.cgColor
        
        viewControllers = tabBarList
        self.selectedIndex = 1
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        HapticHelper.buttonVibro(.light)
    }
    
}
