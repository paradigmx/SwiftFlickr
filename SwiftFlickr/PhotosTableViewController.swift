//
//  PhotosTableViewController.swift
//  SwiftFlickr
//
//  Created by Neo on 9/4/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import UIKit

class PhotosTableViewController: CoreDataTableViewController {

    // MARK: - Table view data source
    // To use this class, the prototype cell should have "Subtitle" style and "Photo Cell" as its identifier
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Photo Cell") as UITableViewCell

        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as Photo
        cell.textLabel?.text = photo.title
        cell.detailTextLabel?.text = photo.subtitle

        return cell
    }

    override func containsPhoto(photo: Photo) -> Bool {
        let indexPath = fetchedResultsController.indexPathForObject(photo)

        return (indexPath != nil)
    }

    // MARK: - Navigation

    private func prepareViewController(var viewController: AnyObject?, forSegueWithIdentifier identifier: String?, withPhoto photo: Photo) {
        if identifier == nil || identifier!.isEmpty || identifier! == "Show Photo" {
            if let navigationController = viewController as? UINavigationController {
                viewController = navigationController.viewControllers.first
            }
            if let photoViewController = viewController as? PhotoViewController {
                photoViewController.photo = photo
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var indexPath: NSIndexPath?
        if sender.isKindOfClass(UITableViewCell) {
            indexPath = tableView.indexPathForCell(sender as UITableViewCell)
            if let photo = fetchedResultsController.objectAtIndexPath(indexPath!) as? Photo {
                prepareViewController(segue.destinationViewController, forSegueWithIdentifier: segue.identifier, withPhoto: photo)
            }
        }
    }

}
