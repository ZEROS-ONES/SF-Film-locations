//
//  MoviesDataKeeper.swift
//  SFMovieLocations
//
//  Created by Sandeep Kumar penchala on 7/30/16.
//  Copyright © 2016 Sandeep Kumar penchala. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class MoviesDataKeeper: NSObject,MoviesDataConnectDelegate {
    private var delegate:MoviesDataKeeperDelegate?
    internal var saveSFMoviesArraytoDB:Bool = false
    
    lazy var sfMoviesDataArray: [SFMovieData]? = {
       return [SFMovieData]()
    }()
    class var sharedInstance: MoviesDataKeeper {
        struct Static {
            static let instance: MoviesDataKeeper = MoviesDataKeeper()
        }
        return Static.instance
    }
    
    internal func getSFMoviesDataService(withDelegate delegate:MoviesDataKeeperDelegate){
        self.delegate = delegate
        let sfMoviesConnectionService = MoviesDataConnectionService()
        sfMoviesConnectionService.loadSFMoviesData(withDelegate: self)
        
    }
    internal func getSFMoviesDataFromDB(withDelegate delegate:MoviesDataKeeperDelegate){
        self.delegate = delegate
        let dataFromDB = retrieveSFMoviesData()
        if let dataFromDB = dataFromDB{
            parseDatawithResponse(dataFromDB)
        }
        else{
            delegate.moviesDataWithFailure(NSError(domain: "Json Parsing error", code: -1, userInfo: [:]))
        }
    }
    
    private func parseDatawithResponse(data: NSData?){
        if let data = data{
            do{
                let dictionary = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
                if let dictionary = dictionary{
                    if let dataDict = dictionary.objectForKey("data") as? [NSArray]{
                        for array in dataDict {
                            let movieData = SFMovieData(withArray: array)
                            sfMoviesDataArray?.append(movieData)
                        }
                        delegate?.moviesDataWithSuccess(sfMoviesDataArray)
                    }
                }
            }
            catch {
                delegate?.moviesDataWithFailure(NSError(domain: "Json Parsing error", code: -1, userInfo: [:]))
            }
        }
        else{
            delegate?.moviesDataWithFailure(NSError(domain: "Json Parsing error", code: -1, userInfo: [:]))
        }
    }
    
    func moviesDataWithFailure(error: NSError?){
        if let error = error{
            delegate?.moviesDataWithFailure(error)
        }
    }
}

extension MoviesDataKeeper{
    internal func checkIfSFMoviesDataExistsinDB() -> Bool?{
        do{
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: "SFMoviesData")
        request.returnsObjectsAsFaults = false
        let results:NSArray = try managedContext.executeFetchRequest(request)
        return results.count > 0
        }
        catch{
            return false
        }
    }
    
    private func saveToDataBase(data: NSData?) -> Bool?{
        if let data = data{
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity =  NSEntityDescription.entityForName("SFMoviesData",
            inManagedObjectContext:managedContext)
        let sfMoviesData = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext: managedContext)
        sfMoviesData.setValue(data, forKey: "jsonResponseBinary")
            do{
                try managedContext.save()
                return true
            }
            catch{
                return false
            }
        }
        else{
            return false
        }
    }
    
    internal func retrieveSFMoviesData() -> NSData?{
        do{
            let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext
            let request = NSFetchRequest(entityName: "SFMoviesData")
            request.returnsObjectsAsFaults = false
            let results:NSArray = try managedContext.executeFetchRequest(request)
            if results.count > 0 {
                if let sfMoviesData = results[0] as? SFMoviesData {
                    return sfMoviesData.jsonResponseBinary
                }
                else{
                    return nil
                }
            }
            else{
                return nil
            }
            
        }
        catch{
            return nil
        }
    }
    
    internal func deleteSFMoviesDataFromDB() -> Bool?{
         do{
         let isExists = checkIfSFMoviesDataExistsinDB()
            if let _ = isExists{
                    let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    let managedContext = appDelegate.managedObjectContext
                    let fetchRequest = NSFetchRequest(entityName: "SFMoviesData")
                    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                try managedContext.persistentStoreCoordinator?.executeRequest(deleteRequest, withContext: managedContext)
                return true
            }
            else{
                return false
            }
        }
         catch{
            return true
        }
    }
}
extension MoviesDataKeeper{
    func moviesDataWithSuccess(data: NSData?){
        if let data = data{
            if saveSFMoviesArraytoDB {
                deleteSFMoviesDataFromDB()
                saveToDataBase(data)
            }
            else{
                deleteSFMoviesDataFromDB()
            }
            parseDatawithResponse(data)
    }
    }
}

        
protocol MoviesDataKeeperDelegate{
    func moviesDataWithSuccess(array: [SFMovieData]?)
    func moviesDataWithFailure(error: NSError?)
}


