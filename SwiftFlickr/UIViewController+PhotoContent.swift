//
//  UIViewController+PhotoContent.swift
//  SwiftFlickr
//
//  Created by Neo on 9/5/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import UIKit

extension UIViewController {

    func containsPhoto(photo: Photo) -> Bool {
        // By default controller contains no photo
        return false
    }

    func displayingPhoto() -> Photo? {
        // By default controller displaying nothing
        return nil
    }

}

extension UINavigationController {

    override func displayingPhoto() -> Photo? {
        return self.viewControllers.first?.displayingPhoto()
    }

}
