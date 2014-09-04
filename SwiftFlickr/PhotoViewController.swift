//
//  PhotoViewController.swift
//  SwiftFlickr
//
//  Created by Neo on 9/2/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var spinner: UIActivityIndicatorView!

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.minimumZoomScale = 0.25
            scrollView.maximumZoomScale = 2
            scrollView.delegate = self

            updatePhotoSize()
        }
    }

    var photoURL: NSURL? {
        didSet {
            downloadPhoto()
        }
    }

    var imageView: UIImageView?

    var image: UIImage? {
        get {
            return imageView?.image
        }
        set {
            imageView?.image = newValue
            updatePhotoSize()

            spinner.stopAnimating()
        }
    }

    private func updatePhotoSize() {
        imageView?.frame = CGRectMake(0.0, 0.0, image?.size.width ?? 0.0, image?.size.height ?? 0.0)
        scrollView.contentSize = image?.size ?? CGSizeZero
        scrollView.zoomScale = 1.0;
    }

    func downloadPhoto() {
        image = nil

        if let url = photoURL {
            spinner.startAnimating()

            let request = NSURLRequest(URL: url)
            let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
            let session = NSURLSession(configuration: configuration)
            // For ephemeral session configuration we can use completion handler, for background session we have to use delegate instead
            var task = session.downloadTaskWithRequest(request, completionHandler: { file, response, error in
                if (error == nil) {
                    if request.URL.isEqual(self.photoURL) {
                        let image = UIImage(data: NSData(contentsOfURL: file))
                        dispatch_async(dispatch_get_main_queue()) {
                            self.image = image
                        }
                    }
                }
            })
            task.resume()
        }
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView!) -> UIView! {
        return imageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView = UIImageView()
        scrollView.addSubview(imageView!)
    }

}
