//
//  AppDelegate.swift
//  SwiftFlickr
//
//  Created by Neo on 9/2/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NSURLSessionDownloadDelegate {
                            
    var window: UIWindow?

    // MARK: - Managed object context initialization w/ UIManagedDocument

    private var applicationDocumentsDirectory: NSURL {
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).last as NSURL
    }

    private let photoDatabaseName = "Photomania"

    private func createPhotoDatabase() {
        if photoDatabase == nil {
            let url = applicationDocumentsDirectory.URLByAppendingPathComponent(photoDatabaseName)
            photoDatabase = UIManagedDocument(fileURL: url)
        }
    }

    private var photoDatabase: UIManagedDocument? {
        didSet {
            if !NSFileManager.defaultManager().fileExistsAtPath(photoDatabase!.fileURL.path!) {
                photoDatabase?.saveToURL(photoDatabase!.fileURL, forSaveOperation: UIDocumentSaveOperation.ForCreating, completionHandler: { (success: Bool) -> Void in
                    self.photoDatabaseContext = self.photoDatabase?.managedObjectContext
                })
            }
            else if self.photoDatabase?.documentState == UIDocumentState.Closed {
                photoDatabase?.openWithCompletionHandler({ (success: Bool) -> Void in
                    self.photoDatabaseContext = self.photoDatabase?.managedObjectContext
                })
            } else if self.photoDatabase?.documentState == UIDocumentState.Normal {
                // No need to do anything here
            }
        }
    }

    private var photoDatabaseContext: NSManagedObjectContext? {
        didSet {
            let userInfo = [PhotoDatabaseAvailabilityContextName: self.photoDatabaseContext!]

            NSNotificationCenter.defaultCenter().postNotificationName(PhotoDatabaseAvailabilityNotificationName, object: self, userInfo: userInfo)
        }
    }

    // MARK: - Application lifecycle

    func application(application: UIApplication!, didFinishLaunchingWithOptions launchOptions: NSDictionary!) -> Bool {
        UIApplication.sharedApplication().setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)

        createPhotoDatabase()
        startFlickrFetch()

        return true
    }

    // MARK: - Flickr fetching

    private let flickrFetchTaskName = "Fetch Task for Just Posted Photos"
    private let foregroundFetchTaskTimeInterval = 20 * 60
    private let backgroundFetchTaskTimeout = 10

    private lazy var flickFetchSession: NSURLSession = {
        struct Singleton {
            static var token: dispatch_once_t = 0
            static var session: NSURLSession? = nil
        }
        dispatch_once(&Singleton.token) {
            let config = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier(self.flickrFetchTaskName)
            Singleton.session = NSURLSession(configuration: config, delegate: self, delegateQueue: nil)
        }
        return Singleton.session!
    }()

    private func startFlickrFetch() {
        flickFetchSession.getTasksWithCompletionHandler { (dataTasks: [AnyObject]!, uploadTasks: [AnyObject]!, downloadTasks: [AnyObject]!) -> Void in
            if downloadTasks.isEmpty {
                let task = self.flickFetchSession.downloadTaskWithURL(FlickrFetcher.URLforRecentGeoreferencedPhotos())
                task.taskDescription = self.flickrFetchTaskName
                task.resume()
            }
            else {
                for task in downloadTasks {
                    (task  as NSURLSessionDownloadTask).resume()
                }
            }
        }
    }

    // MARK: - URL session download delegate

    private func flickrPhotosAtURL(url: NSURL) -> NSArray {
        let flickrJSONData = NSData(contentsOfURL: url)
        let flickrPropertyList = NSJSONSerialization.JSONObjectWithData(flickrJSONData, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
        return flickrPropertyList.valueForKeyPath(FLICKR_RESULTS_PHOTOS) as NSArray
    }

    private func loadFlickrPhotosFromLocalURL(location: NSURL, intoContext context:NSManagedObjectContext?, andThenExecuteBlock done:(() -> Void)!) {
        if let photoContext = context {
            let photos = flickrPhotosAtURL(location)
            photoContext.performBlock({ () -> Void in
                Photo.insertPhotosFromFlickrArray(photos, intoManagedObjectContext: photoContext)
            })
        }
        if let finishedBlock = done {
            finishedBlock()
        }
    }

    func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL) {
        if downloadTask.taskDescription == flickrFetchTaskName {
            loadFlickrPhotosFromLocalURL(location, intoContext: photoDatabaseContext, andThenExecuteBlock: nil)
        }
    }

    func URLSession(session: NSURLSession!, task: NSURLSessionTask!, didCompleteWithError error: NSError!) {
        if error != nil {
            NSLog("Flickr background download session failed: %@", error.localizedDescription)
        }
    }

}

