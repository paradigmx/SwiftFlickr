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

    private var useEmbeddedMapView: Bool {
        get {
            if splitViewController != nil {
                if let traitOverrideViewController = splitViewController?.parentViewController as? TraitOverrideViewController {
                    return traitOverrideViewController.traitOverrided
                }
            }
            return false
        }
    }

    private var photoViewController: PhotoViewController? {
        get {
            if var detail: AnyObject = splitViewController?.viewControllers.last {
                if let navigationController = detail as? UINavigationController {
                    detail = navigationController.viewControllers.first!
                }
                if let photoViewController = detail as? PhotoViewController {
                    return photoViewController
                }
            }
            return nil
        }
    }

    override func containsPhoto(photo: Photo) -> Bool {
        return true
    }

    // MARK: - Table view controller data source

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Photographer Cell") as UITableViewCell
        let photographer = fetchedResultsController.objectAtIndexPath(indexPath) as Photographer

        cell.textLabel.text = photographer.name
        cell.detailTextLabel?.text = NSString(format: "%d photos", photographer.photos.count)

        return cell
    }

    // MARK: - Table view controller delegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if useEmbeddedMapView {
            if photoViewController != nil {
                if let photographer = fetchedResultsController.objectAtIndexPath(indexPath) as? Photographer {
                    prepareViewController(photoViewController, forSegueWithIdentifier: nil, withPhotographer: photographer)
                }
            }
        }
    }

    // MARK: - Navigation

    private func prepareViewController(var viewController: AnyObject?, forSegueWithIdentifier identifier: String?, withPhotographer photographer: Photographer) {
        if identifier == nil || identifier!.isEmpty || identifier! == "Show Photos by Photographer" {
            if let navigationController = viewController as? UINavigationController {
                viewController = navigationController.viewControllers.first
            }
            if let photoViewController = viewController as? PhotosByPhotographerViewController {
                photoViewController.photographer = photographer
            }
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "Show Photos by Photographer" {
            return !useEmbeddedMapView
        }

        return super.shouldPerformSegueWithIdentifier(identifier, sender: sender)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var indexPath: NSIndexPath?
        if let cell = sender as? UITableViewCell {
            indexPath = tableView.indexPathForCell(cell)
            let photographer = fetchedResultsController.objectAtIndexPath(indexPath!) as Photographer
            prepareViewController(segue.destinationViewController, forSegueWithIdentifier: segue.identifier, withPhotographer: photographer)
        }
    }

}
