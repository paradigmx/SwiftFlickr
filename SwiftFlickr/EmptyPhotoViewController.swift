//
//  EmptyPhotoViewController.swift
//  SwiftFlickr
//
//  Created by Neo on 9/5/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import UIKit

class EmptyPhotoViewController: UIViewController {

    override func loadView() {
        var view = UIView()
        view.backgroundColor = UIColor.whiteColor()

        var label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.text = "Nothing Selected"
        label.textColor = UIColor(white: 0.0, alpha: 0.4)
        label.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        view.addSubview(label)

        view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0.0))

        self.view = view
    }

}
