//
//  CustomImageView.swift
//  ImageLoaderIndicator
//
//  Created by lmh on 2018/1/16.
//  Copyright © 2018年 SK. All rights reserved.
//

import UIKit

class CustomImageView: UIImageView {

    let progressIndicatorView = CircularLoaderView(frame: .zero)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addSubview(progressIndicatorView)
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v]|", options: .init(rawValue: 0),
            metrics: nil, views: ["v": progressIndicatorView]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[v]|", options: .init(rawValue: 0),
            metrics: nil, views:  ["v": progressIndicatorView]))
        
        progressIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        
        let url = URL(string: "https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=1920270919,646231037&fm=27&gp=0.jpg")
        sd_setImage(with: url, placeholderImage: nil, options: .cacheMemoryOnly, progress:
            { [weak self] receivedSize, expectedSize, _ in
                // Update progress here
                self?.progressIndicatorView.progress = CGFloat(receivedSize) / CGFloat(expectedSize)
        }) { [weak self] _, error, _, _ in
            // Reveal image here
            if let error = error {
                print(error)
            }
            
            self?.progressIndicatorView.reveal()
            
        }
    }
    

    
    
}
