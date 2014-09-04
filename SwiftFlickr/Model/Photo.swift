//
//  Photo.swift
//  SwiftFlickr
//
//  Created by Neo on 9/2/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import Foundation
import CoreData

class Photo: NSManagedObject {

    @NSManaged var title: String
    @NSManaged var subtitle: String
    @NSManaged var url: String
    @NSManaged var id: String
    @NSManaged var photographer: Photographer

}
