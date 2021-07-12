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
    }
    
    func setupTabBar() {
        let avatar = UIStoryboard(name: "Avatar", bundle: nil)

        guard let firstVC = avatar.instantiateViewController(withIdentifier: "AvatarViewController") as? AvatarViewController else { return }

        let shop = UIStoryboard(name: "Shop", bundle: nil)
        guard let secondVC = shop.instantiateViewController(withIdentifier: "ShopViewController") as? ShopViewController else { return }

        let tabBarList = [firstVC, secondVC]
    
        tabBar.isTranslucent = true
        tabBar.tintColor = UIColor(named: "lightGray")
        tabBar.barStyle = .blackOpaque
        viewControllers = tabBarList
        self.selectedIndex = 0
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        HapticHelper.buttonVibro(.light)
    }
    
}
