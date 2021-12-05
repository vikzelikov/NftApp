//
//  ImageView.swift
//  NftApp
//
//  Created by Yegor on 05.12.2021.
//

import Foundation
import UIKit
import SDWebImage

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    
    func load(with: URL) {
        self.sd_imageTransition = .fade(duration: 0.35)
        self.sd_setImage(with: with)
    }
    
//    func load(with url: URL) {
//        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
//            self.image = cachedImage
//            return
//        }
//
//        self.alpha = 0.0
//
//        URLSession.shared.dataTask(with: url) { (data, _, _) in
//            if let data = data, let image = UIImage(data: data) {
//                DispatchQueue.main.async { [weak self] in
////                    imageCache.setObject(image, forKey: url.absoluteString as NSString)
//                    self?.image = image
//
//                    UIView.animate(withDuration: 0.35, animations: { () -> Void in
//                        self?.alpha = 1.0
//                    })
//                }
//            }
//        }.resume()
//    }
    
}
