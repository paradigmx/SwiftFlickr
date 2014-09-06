//
//  Photo+Flickr.swift
//  SwiftFlickr
//
//  Created by Neo on 9/2/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import Foundation
import CoreData

extension Photo {

    class func entityName() -> String { return "Photo" }

    class func photoWithFlickrInfo(photoInfo: NSDictionary, inManagedObjectContext context: NSManagedObjectContext) -> Photo? {
        var photo: Photo?

        let id = photoInfo[FLICKR_PHOTO_ID] as String
        let request = NSFetchRequest(entityName: Photo.entityName())
        request.predicate = NSPredicate(format: "id = %@", id)

        var error: NSError? = nil
        let matches = context.executeFetchRequest(request, error: &error)

        if (error != nil || matches!.count > 1) {
            // Error handling
        }
        else if (matches!.count > 0) {
            photo = matches!.first as Photo?
        }
        else {
            photo = NSEntityDescription.insertNewObjectForEntityForName(Photo.entityName(), inManagedObjectContext: context) as Photo?
            photo!.id = id
            photo!.title = photoInfo.valueForKeyPath(FLICKR_PHOTO_TITLE) as String
            photo!.subtitle = photoInfo.valueForKeyPath(FLICKR_PHOTO_DESCRIPTION) as String
            photo!.url = FlickrFetcher.URLforPhoto(photoInfo, format: FlickrPhotoFormatLarge).absoluteString!

            let photographerName = photoInfo.valueForKeyPath(FLICKR_PHOTO_OWNER) as String
            photo!.photographer = Photographer.photographerWithName(photographerName, inManagedObjectContext: context)!
        }

        return photo
    }

    class func insertPhotosFromFlickrArray(photos: NSArray, intoManagedObjectContext context: NSManagedObjectContext) {
        for photo in photos {
            Photo.photoWithFlickrInfo(photo as NSDictionary, inManagedObjectContext: context)
        }
    }

}