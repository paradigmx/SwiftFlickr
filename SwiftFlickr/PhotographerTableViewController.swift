//
//  PhotographerTableViewController.swift
//  SwiftFlickr
//
//  Created by Neo on 9/2/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import UIKit

class PhotographerTableViewController: CoreDataTableViewController {

    override func awakeFromNib() {
        super.awakeFromNib()

        NSNotificationCenter.defaultCenter().addObserverForName(PhotoDatabaseAvailabilityNotificationName, object: nil, queue: nil, { (note: NSNotification!) -> Void in
            self.photoDatabaseContext = note.userInfo![PhotoDatabaseAvailabilityContextName] as? NSManagedObjectContext
        })
    }

    private var photoDatabaseContext: NSManagedObjectContext? {
        didSet {
            if let context = photoDatabaseContext {
                var request = NSFetchRequest(entityName: Photographer.entityName())
                request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true, selector:"localizedStandardCompare:")]
                fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            }
        }
    }

    override func containsPhoto(photo: Photo) -> Bool {
        return true
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Photographer Cell") as UITableViewCell
        let photographer = fetchedResultsController.objectAtIndexPath(indexPath) as Photographer

        cell.textLabel?.text = photographer.name
        cell.detailTextLabel?.text = NSString(format: "%d photos", photographer.photos.count)

        return cell
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var indexPath: NSIndexPath?
        if let cell = sender as? UITableViewCell {
            indexPath = tableView.indexPathForCell(cell)
            let photographer = fetchedResultsController.objectAtIndexPath(indexPath!) as Photographer
            if let photosViewController = segue.destinationViewController as? PhotosByPhotographerViewController {
                photosViewController.photographer = photographer
            }
        }
    }

}
