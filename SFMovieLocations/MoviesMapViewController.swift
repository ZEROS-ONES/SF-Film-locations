//
//  MoviesMapViewController.swift
//  SFMovieLocations
//
//  Created by Sandeep Kumar penchala on 7/30/16.
//  Copyright © 2016 Sandeep Kumar penchala. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MoviesMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    internal var movieData:SFMovieData?
    var currentLocation:CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMapCoordinatesFromLocationString(movieData)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setMapCoordinatesFromLocationString(movieData: SFMovieData?){
        guard let movieData = movieData else{
            showError()
            return
        }
        guard let movieDataArray = movieData.movieDataWithIndexArray else{
            showError()
            return
        }
        let parsedLocationString = movieDataArray[Constants.MOVIE_LOCATION_INDEX].value as? String
        
        guard let locationString = parsedLocationString else{
            showError()
            return
        }
        let geocoder: CLGeocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString ,completionHandler: {(placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if (placemarks?.count > 0) {
                let topResult: CLPlacemark = (placemarks?[0])!
                let placemark: MKPlacemark = MKPlacemark(placemark: topResult)
                var region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(placemark.coordinate, 500, 500)
                self.mapView.setCenterCoordinate(region.center, animated: true)
                self.mapView.setRegion(region, animated: true)
                self.mapView.addAnnotation(placemark)
            }
            else{
                self.showError()
            }
        })
    }
    
    private func showError(){
        let alertController = UIAlertController(title: "Error", message:
            "Error while loading location Address :-(", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}
extension MoviesMapViewController: MKMapViewDelegate{
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        return nil
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(2 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            var index:Double! = -1
            for aV in views {
                index = index + 1
                if let aV: MKAnnotationView = aV {
                    let endFrame: CGRect = aV.frame;
                    aV.frame =  CGRectMake(aV.frame.origin.x, aV.frame.origin.y - 300.0, aV.frame.size.width, aV.frame.size.height);
                    
                    let timeInterVal = 0.1 * index
                    UIView.animateWithDuration(0.4, delay: timeInterVal, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                        aV.frame = endFrame
                        }, completion: { (finished) -> Void in
                            if finished{
                                UIView.animateWithDuration(0.05, animations: { () -> Void in
                                    aV.transform = CGAffineTransformMakeScale(1.0, 0.8)
                                    }, completion: { (finished) -> Void in
                                        aV.transform = CGAffineTransformIdentity
                                })
                            }
                    })
                }
            }
        }
    }
}

