//
//  Photographer.swift
//  SwiftFlickr
//
//  Created by Neo on 9/2/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import Foundation
import CoreData

class Photographer: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var photos: NSSet

}
