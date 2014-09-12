//
//  SwiftFlickr.swift
//  SwiftFlickr
//
//  Created by Neo on 9/12/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import Foundation
import CoreData

class Photo: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var subtitle: String
    @NSManaged var thumbnailURL: String
    @NSManaged var title: String
    @NSManaged var url: String
    @NSManaged var photographer: SwiftFlickr.Photographer

}
