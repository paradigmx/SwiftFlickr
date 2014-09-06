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
        (cell.textLabel)!.text = photo.title
        (cell.detailTextLabel)!.text = photo.subtitle

        return cell
    }

    override func containsPhoto(photo: Photo) -> Bool {
        let indexPath = fetchedResultsController.indexPathForObject(photo)

        return (indexPath != nil)
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var indexPath: NSIndexPath?
        if (sender.isKindOfClass(UITableViewCell)) {
            indexPath = tableView.indexPathForCell(sender as UITableViewCell)
            let photo = fetchedResultsController.objectAtIndexPath(indexPath!) as Photo

            var photoViewController: PhotoViewController? = nil
            if (segue.destinationViewController.isKindOfClass(UINavigationController)) {
                let detailViewController = segue.destinationViewController as UINavigationController
                photoViewController = detailViewController.viewControllers.first as? PhotoViewController
            }
            if (segue.destinationViewController.isKindOfClass(PhotoViewController)) {
                photoViewController = segue.destinationViewController as? PhotoViewController
            }
            photoViewController!.photo = photo
        }
    }

}
