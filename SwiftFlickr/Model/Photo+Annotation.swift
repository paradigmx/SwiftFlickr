//
//  Photo+Annotation.swift
//  SwiftFlickr
//
//  Created by Neo on 9/12/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import Foundation
import CoreData
import MapKit

extension Photo: MKAnnotation {

    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self.latitude.doubleValue, longitude: self.longitude.doubleValue)
        }
    }

}