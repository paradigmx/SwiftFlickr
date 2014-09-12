//
//  Photographer+Create.swift
//  SwiftFlickr
//
//  Created by Neo on 9/2/14.
//  Copyright (c) 2014 Paradigm X. All rights reserved.
//

import Foundation
import CoreData

extension Photographer {

    class func entityName() -> String { return "Photographer" }

    class func photographerWithName(name: String, inManagedObjectContext context: NSManagedObjectContext) -> Photographer? {
        var photographer: Photographer? = nil

        if !name.isEmpty {
            let request = NSFetchRequest(entityName: Photographer.entityName())
            request.predicate = NSPredicate(format: "name = %@", name)

            var error: NSError? = nil
            let matches = context.executeFetchRequest(request, error: &error)

            if error != nil || matches!.count > 1 {
                // Error handling
            }
            else if matches!.count > 0 {
                photographer = matches!.first as Photographer?
            }
            else {
                photographer = NSEntityDescription.insertNewObjectForEntityForName(Photographer.entityName(), inManagedObjectContext: context) as Photographer?
                photographer!.name = name
            }
        }

        return photographer
    }

}