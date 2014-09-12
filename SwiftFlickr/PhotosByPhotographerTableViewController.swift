//
//  PhotosByPhotographerTableViewController.swift
//  SwiftFlickr
//
//  Created by Neo on 9/4/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import UIKit

class PhotosByPhotographerTableViewController: PhotosTableViewController, PhotosByPhotographerViewController {

    var photographer: Photographer? {
        didSet {
            title = photographer!.name
            setupFetchResultController()
        }
    }

    private func setupFetchResultController() {
        if let context = photographer?.managedObjectContext {
            var request = NSFetchRequest(entityName: Photo.entityName())
            request.predicate = NSPredicate(format: "photographer = %@", photographer!)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: "localizedStandardCompare:")]

            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
        else {
            fetchedResultsController = nil
        }

    }

}
