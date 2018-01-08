//
//  MapViewController.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 06/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
import FoldingTabBar

class MapViewController: UIViewController , MKMapViewDelegate,CLLocationManagerDelegate,YALTabBarDelegate{
   
    @IBOutlet weak var map: MKMapView!
    var babysitters:[JSON]? = nil
    var locationManager: CLLocationManager!
    var rad : CLLocationDistance = 10000
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        currentLocationButtonAction()
        getBabysitters()

    
    }
    func currentLocationButtonAction() {
        if (CLLocationManager.locationServicesEnabled()) {
            if locationManager == nil {
                locationManager = CLLocationManager()
            }
            locationManager?.requestWhenInUseAuthorization()
            locationManager.delegate = self
            locationManager.distanceFilter = 100
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        let circle = MKCircle(center: userLocation.coordinate, radius: rad)
        map.add(circle)
        
        //UpdateBabyistters
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func getBabysitters()   {
        Alamofire.request(AppDelegate.serverUrlTaha+"getBabysitters", method: .get)
            
            .responseJSON { response in
                
                if let json = response.data {
                    let data = JSON(data: json)
                    
                    self.babysitters = data.arrayValue
                    self.populateMap()
                    
                }
        }
    }
    func populateMap(){
        for babysitter in babysitters! {
            
            let marker = BabySitterPin(title: babysitter["firstname"].stringValue + " " + babysitter["lastname"].stringValue,
                                  locationName: babysitter["descr"].stringValue,
                                  discipline: "Babysitter",
                                  coordinate: CLLocationCoordinate2D(latitude: Double((babysitter["altitude"].stringValue))!, longitude: Double((babysitter["longitude"].stringValue))!))
            map.addAnnotation(marker)
            
        }
    }
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let circle = overlay as? MKCircle {
                let renderer = MKCircleRenderer.init(overlay: circle)
                renderer.fillColor = UIColor.green
                renderer.alpha = 0.1
                return renderer
            }
            return MKOverlayRenderer()
        // You can either return your square here, or ignore the circle check and only return circles.
    }

    func tabBarDidSelectExtraRightItem(_ tabBar: YALFoldingTabBar) {
        //apply filtres
    }

}


