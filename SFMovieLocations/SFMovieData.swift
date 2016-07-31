//
//  SFMovieData.swift
//  SFMovieLocations
//
//  Created by Sandeep Kumar penchala on 7/30/16.
//  Copyright © 2016 Sandeep Kumar penchala. All rights reserved.
//

import Foundation
class SFMovieData: NSObject {
    lazy var movieDataWithIndexArray:[MovieDataWithIndex]? = {
       return [MovieDataWithIndex]()
    }()
    internal init(withArray array: NSArray?) {
        super.init()
        if let array = array{
            for var i = 0; i<array.count; i++ {
                var movieDataWithIndex = MovieDataWithIndex()
                movieDataWithIndex.index = i
                movieDataWithIndex.name = getNameByIndex(i)
                movieDataWithIndex.value = array[i]
                movieDataWithIndexArray?.append(movieDataWithIndex)
                #if DEBUG
                print("\(movieDataWithIndex.index) " + " \(movieDataWithIndex.name) " + " \(movieDataWithIndex.value)")
                #endif
            }
        }
    }
    override init() {
        
    }
    
    private func getNameByIndex(index: Int)->String?{
        switch(index){
        case 0:
            return "sid"
        case 1:
            return "id"
        case 2:
            return "position"
        case 3:
            return "created_at"
        case 4:
            return "ceated_meta"
        case 5:
            return "updated_at"
        case 6:
            return "updated_meta"
        case 7:
            return "meta_data"
        case 8:
            return "Title"
        case 9:
            return "Release Year"
        case 10:
            return "Locations"
        case 11:
            return "Fun Facts"
        case 12:
            return "Production Company"
        case 13:
            return "Distributor"
        case 14:
            return "Director"
        case 15:
            return "Writer"
        case 16:
            return "Actor 1"
        case 17:
            return "Actor 2"
        case 18:
            return "Actor 3"
        default :
            return nil
        }
    }
    
}
struct MovieDataWithIndex {
    var index: Int?
    var name: String?
    var value: AnyObject?
}
