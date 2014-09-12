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
            mapView.delegate = self
            updateMapViewAnnotations()
        }
    }

    private lazy var photosByPhotographer: NSArray? = self.fetchPhotosByPhotographer()

    var photographer: Photographer? {
        didSet {
            if photographer != nil {
                title = photographer!.name
                photosByPhotographer = fetchPhotosByPhotographer()
                updateMapViewAnnotations()
            }
        }
    }

    private func fetchPhotosByPhotographer() -> NSArray? {
        if photographer != nil {
            var request = NSFetchRequest(entityName: Photo.entityName())
            request.predicate = NSPredicate(format: "photographer = %@", photographer!)
            return photographer?.managedObjectContext.executeFetchRequest(request, error: nil)
        }

        return nil
    }

    private var selectedPhoto: Photo?

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

    private func updateMapViewAnnotations() {
        if mapView != nil {
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotations(photosByPhotographer)
            mapView.showAnnotations(photosByPhotographer, animated: true)

            if photoViewController != nil {
                if let photo = photosByPhotographer?.firstObject as? Photo {
                    mapView.selectAnnotation(photo, animated: true)
                    prepareViewController(photoViewController, forSegueWithIdentifier: nil, withAnnotation: photo)
                }
            }
        }
    }

    override func containsPhoto(photo: Photo) -> Bool {
        return mapView.annotations.contains(photo)
    }

    // MARK: - Map view delegate

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        let reuseIdentifier = "Photo by Photographer"
        var view = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        if view == nil {
            view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            view.canShowCallout = true

            if photoViewController == nil {
                view.leftCalloutAccessoryView = UIImageView(frame: CGRectMake(0, 0, 46, 46))
                view.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as UIView
            }
        }
        view.annotation = annotation
        return view
    }

    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        if photoViewController != nil {
            prepareViewController(photoViewController, forSegueWithIdentifier: nil, withAnnotation: view.annotation)
        }
        else {
            updateThumbnailInAnnotationView(view)
        }
    }

    private func updateThumbnailInAnnotationView(annotationView: MKAnnotationView) {
        if let imageView = annotationView.leftCalloutAccessoryView as? UIImageView {
            if let photo = annotationView.annotation as? Photo {
                selectedPhoto = photo
                dispatch_async(dispatch_queue_create("FlickrFetch", nil)) {
                    let image = UIImage(data: NSData(contentsOfURL: NSURL(string: photo.thumbnailURL)))
                    if photo == self.selectedPhoto {
                        dispatch_async(dispatch_get_main_queue()) { imageView.image = image }
                    }
                }
            }
        }
    }

    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        performSegueWithIdentifier("Show Photo", sender: view)
    }

    // MARK: - Navigation

    private func prepareViewController(var viewController: AnyObject?, forSegueWithIdentifier identifier: String?, withAnnotation annotatioin: MKAnnotation) {
        if let photo = annotatioin as? Photo {
            if identifier == nil || identifier!.isEmpty || identifier! == "Show Photo" {
                if let navigationController = viewController as? UINavigationController {
                    viewController = navigationController.viewControllers.first
                }
                if let photoViewController = viewController as? PhotoViewController {
                    photoViewController.photo = photo
                }
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let annotationView = sender as? MKAnnotationView {
            prepareViewController(segue.destinationViewController, forSegueWithIdentifier: segue.identifier, withAnnotation: annotationView.annotation)
        }
    }

}
