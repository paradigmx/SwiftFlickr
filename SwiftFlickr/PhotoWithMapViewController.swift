//
//  PhotoWithMapViewController.swift
//  SwiftFlickr
//
//  Created by Neo on 9/12/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import UIKit

class PhotoWithMapViewController: PhotoViewController, PhotosByPhotographerViewController {
    
    var photographer: Photographer? {
        didSet {
            title = photographer!.name
            mapViewController?.photographer = photographer
        }
    }

    private var mapViewController: PhotosByPhotographerMapViewController?

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let mapViewController = segue.destinationViewController as? PhotosByPhotographerMapViewController {
            mapViewController.photographer = photographer
            self.mapViewController = mapViewController
        }
        else {
            super.prepareForSegue(segue, sender: sender)
        }
    }

}
