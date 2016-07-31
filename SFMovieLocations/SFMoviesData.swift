//
//  SFMoviesData.swift
//  SFMovieLocations
//
//  Created by Sandeep Kumar penchala on 7/30/16.
//  Copyright © 2016 Sandeep Kumar penchala. All rights reserved.
//

import Foundation
import CoreData
@objc(SFMoviesData)
class SFMoviesData: NSManagedObject {
    @NSManaged var jsonResponseBinary:NSData?
}