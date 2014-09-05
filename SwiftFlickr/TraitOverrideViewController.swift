//
//  TraitOverrideViewController.swift
//  SwiftFlickr
//
//  Created by Neo on 9/2/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import UIKit

class TraitOverrideViewController: UIViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        overrideTraitCollectionForSize(view.bounds.size)
        configureSplitViewController()
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator!) {
        overrideTraitCollectionForSize(size)

        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }

    private func overrideTraitCollectionForSize(size: CGSize) {
        var overrideTraitCollection: UITraitCollection? = nil
        if size.width > 320 {
            overrideTraitCollection = UITraitCollection(horizontalSizeClass: .Regular)
        }
        for vc in self.childViewControllers as [UIViewController] {
            setOverrideTraitCollection(overrideTraitCollection, forChildViewController: vc)
        }
    }

    private func configureSplitViewController() {
        let splitViewController = self.childViewControllers.first as UISplitViewController
        splitViewController.delegate = self
        splitViewController.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        splitViewController.preferredPrimaryColumnWidthFraction = 0.3
    }

    override func shouldAutomaticallyForwardAppearanceMethods() -> Bool {
        return true
    }

    override func shouldAutomaticallyForwardRotationMethods() -> Bool {
        return true
    }

    // MARK: - Split view controller delegate

    func splitViewController(splitViewController: UISplitViewController!, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        // If our secondary controller doesn't show anything, do the collapse ourself by doing nothing
        var photoViewController: PhotoViewController?
        if let secondaryNavigationController = secondaryViewController as? UINavigationController {
            photoViewController = secondaryNavigationController.viewControllers.first as? PhotoViewController
        }
        else {
            photoViewController = secondaryViewController as? PhotoViewController
        }
        let photo = photoViewController?.displayingPhoto()
        if photo == nil {
            return true
        }

        // Before collapsing, remove any view controllers on our stack that don't match the photo we are about to merge on
        if let primaryNavigationController = primaryViewController as? UINavigationController {
            var viewControllers = NSMutableArray()
            for controller in primaryNavigationController.viewControllers as [UIViewController] {
                if controller.containsPhoto(photo!) {
                    viewControllers.addObject(controller)
                }
            }
            primaryNavigationController.setViewControllers(viewControllers, animated: false)
        }

        return false
    }

    func splitViewController(splitViewController: UISplitViewController!, separateSecondaryViewControllerFromPrimaryViewController primaryViewController: UIViewController!) -> UIViewController! {
        if let primaryNavigationController = primaryViewController as? UINavigationController {
            for controller in primaryNavigationController.viewControllers as [UIViewController] {
                if (controller.displayingPhoto() != nil) {
                    // Do the standard behavior if we have a photo
                    return nil
                }
            }
        }

        // If there's no content on the navigation stack, make an empty view controller for the detail side
        return EmptyPhotoViewController()
    }

}
