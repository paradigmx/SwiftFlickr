//
//  UIViewController+Showing.swift
//  SwiftFlickr
//
//  Created by Neo on 9/5/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import UIKit

extension UIViewController {

    // Returns whether calling showViewController:sender: would cause a navigation "push" to occur
    func willShowingViewControllerPushWithSender(sender: AnyObject) -> Bool {
        // Find and ask the right view controller about showing
        if let target = self.targetViewControllerForAction("willShowingViewControllerPushWithSender", sender: sender) {
            return target.willShowingViewControllerPushWithSender(sender)
        } else {
            // Or if we can't find one, we won't be pushing
            return false
        }
    }

    // Returns whether calling showDetailViewController:sender: would cause a navigation "push" to occur
    func willShowingDetailViewControllerPushWithSender(sender: AnyObject) -> Bool {
        // Find and ask the right view controller about showing
        if let target = self.targetViewControllerForAction("willShowingDetailViewControllerPushWithSender", sender: sender) {
            return target.willShowingViewControllerPushWithSender(sender)
        } else {
            // Or if we can't find one, we won't be pushing
            return false
        }
    }

}

extension UINavigationController {

    // Returns whether calling showViewController:sender: would cause a navigation "push" to occur
    override func willShowingViewControllerPushWithSender(sender: AnyObject) -> Bool {
        // Navigation Controllers always push for showViewController:
        return true
    }

}

extension UISplitViewController {

    // Returns whether calling showViewController:sender: would cause a navigation "push" to occur
    override func willShowingViewControllerPushWithSender(sender: AnyObject) -> Bool {
        // Split View Controllers never push for showViewController:
        return false
    }

    // Returns whether calling showDetailViewController:sender: would cause a navigation "push" to occur
    override func willShowingDetailViewControllerPushWithSender(sender: AnyObject) -> Bool {
        if (self.collapsed) {
            // If we're collapsed, re-ask this question as showViewController: to our primary view controller
            let target = self.viewControllers.last as UIViewController
            return target.willShowingViewControllerPushWithSender(sender)
        } else {
            // Otherwise, we don't push for showDetailViewController:
            return false
        }
    }

}
