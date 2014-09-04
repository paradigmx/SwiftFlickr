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
        // Set up split view delegate
        let splitViewController = self.childViewControllers[0] as UISplitViewController
        splitViewController.delegate = self
        splitViewController.preferredPrimaryColumnWidthFraction = 0.3
        let navigationController = splitViewController.childViewControllers.last as UINavigationController
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem()
    }

    // MARK: - Split view controller delegate

    func splitViewController(splitViewController: UISplitViewController!, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        return false
    }

}
