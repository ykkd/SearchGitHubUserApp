//
//  UIImage+Extension.swift
//  SearchGitHubUserApp
//
//  Created by Yuki Kanda on 2020/04/07.
//  Copyright © 2020 Yuki Kanda. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func imageForPlaceHolder() -> UIImage {
        return UIImage(named: "placeholder")!
    }
    
    static func imageForHeadline(url:String,completion: @escaping (UIImage) -> ()){
        guard let imageURL = URL(string:url) else {
            completion(UIImage.imageForPlaceHolder())
            return
        }
        
        DispatchQueue.main.async {
            if let data = try? Data(contentsOf: imageURL) {
                if let downloadImage = UIImage(data:data){
                    completion(downloadImage)
                }
            }
        }
    }
}
