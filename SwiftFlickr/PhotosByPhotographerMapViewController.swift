//
//  PhotosByPhotographerMapViewController.swift
//  SwiftFlickr
//
//  Created by Neo on 9/12/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import UIKit
import MapKit

class PhotosByPhotographerMapViewController: UIViewController, PhotosByPhotographerViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
//            mapView.delegate = self
            updateMapViewAnnotations()
        }
    }

    private lazy var photosByPhotographer: NSArray? = self.fetchPhotosByPhotographer()

    var photographer: Photographer? {
        didSet {
            title = photographer!.name
            photosByPhotographer = fetchPhotosByPhotographer()
            updateMapViewAnnotations()
        }
    }

    private func fetchPhotosByPhotographer() -> NSArray? {
        var request = NSFetchRequest(entityName: Photo.entityName())
        request.predicate = NSPredicate(format: "photographer = %@", photographer!)
        return photographer?.managedObjectContext.executeFetchRequest(request, error: nil)
    }

    private func updateMapViewAnnotations() {
        if mapView != nil {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(photosByPhotographer)
            mapView.showAnnotations(photosByPhotographer, animated: true)
        }
    }

}
