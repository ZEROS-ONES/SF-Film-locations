//
//  MoviesDataConnectionService.swift
//  SFMovieLocations
//
//  Created by Sandeep Kumar penchala on 7/30/16.
//  Copyright © 2016 Sandeep Kumar penchala. All rights reserved.
//

import Foundation
class MoviesDataConnectionService: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate{
    private var delegate: MoviesDataConnectDelegate?
    
    override init(){
        
    }
    
    internal func loadSFMoviesData(withDelegate delegate: MoviesDataConnectDelegate?){
        self.delegate = delegate
        self.sendRequestTogetMoviesData(Constants.SF_MOVIES_DATA_API_URL)
        
    }
    private func sendRequestTogetMoviesData(urlString : String){
        guard let url = NSURL(string: urlString) else{
            return
        }
        let request = NSURLRequest(URL: url)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) {[weak self](data, response, error) -> Void in
            if (error != nil){
                #if DEBUG
                    print(error?.description)
                #endif
                self?.delegate?.moviesDataWithFailure(error)
            }
            else {
                self?.delegate?.moviesDataWithSuccess(data)
            }
        }
        //start/send request
        task.resume()
    }
}
public protocol MoviesDataConnectDelegate{
    func moviesDataWithSuccess(data: NSData?)
    func moviesDataWithFailure(error: NSError?)
}