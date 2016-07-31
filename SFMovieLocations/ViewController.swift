//
//  ViewController.swift
//  SFMovieLocations
//
//  Created by Sandeep Kumar penchala on 7/30/16.
//  Copyright © 2016 Sandeep Kumar penchala. All rights reserved.
//

import UIKit

class ViewController: UITableViewController,MoviesDataKeeperDelegate {
    private var moviesDataKeeper: MoviesDataKeeper = MoviesDataKeeper.sharedInstance
    private var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    override func viewDidLoad() {
        super.viewDidLoad()
         showActivityIndicator()
        //Check if cache data already exists
        if moviesDataKeeper.checkIfSFMoviesDataExistsinDB() == true{
            moviesDataKeeper.getSFMoviesDataFromDB(withDelegate: self)
        }
            //fetch from service
        else{
            moviesDataKeeper.saveSFMoviesArraytoDB = true
            moviesDataKeeper.getSFMoviesDataService(withDelegate: self)
        }
    }
    
    private func showActivityIndicator(){
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.redColor()
        self.view.addSubview(activityIndicator)
        self.view.userInteractionEnabled = false
    }
    
    private func hideActivityIndicator(){
        self.activityIndicator.removeFromSuperview()
        self.view.userInteractionEnabled = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
}

extension ViewController{
    func moviesDataWithSuccess(array: [SFMovieData]?){
        //Refresh tableView on Main queue
        dispatch_async(dispatch_get_main_queue()){
            self.tableView.reloadData()
            self.hideActivityIndicator()
        }
    }
    
    func moviesDataWithFailure(error: NSError?){
         //Refresh tableView on Main queue
         dispatch_async(dispatch_get_main_queue()){
            self.hideActivityIndicator()
            self.showError(error)
        }
    }
    private func showError(error: NSError?){
        let alertController = UIAlertController(title: "Error", message:
            "something went wrong" + " 😖", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension ViewController{
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ListViewCell", forIndexPath: indexPath)
        if let dataArray = moviesDataKeeper.sfMoviesDataArray{
            let sfMovieData = dataArray[indexPath.row]
            if let movieDataArray = sfMovieData.movieDataWithIndexArray{
            if let movieTitle = movieDataArray[Constants.MOVIE_NAME_INDEX].value {
                cell.textLabel?.text = movieTitle as? String
            }
            else{
                cell.textLabel?.text = ""
            }
                if let movieYear = movieDataArray[Constants.MOVIE_YEAR_INDEX].value {
                    cell.detailTextLabel?.text = movieYear as? String
                }
                if let movieLocation = movieDataArray[Constants.MOVIE_LOCATION_INDEX].value as? String{
                    var movieYear = ""
                    if let labelDetailText = cell.detailTextLabel?.text{
                        movieYear = labelDetailText
                    }
                    cell.detailTextLabel?.text =  movieYear + ", " + movieLocation
                }
        }
    }
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let dataArray = moviesDataKeeper.sfMoviesDataArray{
            return dataArray.count
        }
        return 0
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let mapViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MapViewcontroller") as! MoviesMapViewController
        if let sfMoviesDataArray = moviesDataKeeper.sfMoviesDataArray{
            mapViewController.movieData = sfMoviesDataArray[indexPath.row]
        }
        self.navigationController?.pushViewController(mapViewController, animated: true)
    }
    
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell,
        forRowAtIndexPath indexPath: NSIndexPath) {
            
            // Change separator inset
            if cell.respondsToSelector("setSeparatorInset:") {
                cell.separatorInset = UIEdgeInsetsZero
            }
            
            // Prevent the cell from inheriting the Table View's margin settings
            if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
                cell.preservesSuperviewLayoutMargins = false
            }
            
            // Explictly set cell's layout margins
            if cell.respondsToSelector("setLayoutMargins:") {
                cell.layoutMargins = UIEdgeInsetsZero
            }
    }

}
