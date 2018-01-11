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
import PopupDialog

class MapViewController: UIViewController , MKMapViewDelegate,CLLocationManagerDelegate,YALTabBarDelegate{
    var userLocation:CLLocation!
    @IBOutlet weak var map: MKMapView!
    var babysitters:[JSON]!
    var circle:MKCircle? = nil
    var locationManager: CLLocationManager!
    var annotations : [MKAnnotation] = []
    var rad : CLLocationDistance = 100000
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        currentLocationButtonAction()

    
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
        userLocation = locations[0] as CLLocation
        AppDelegate.userLocation = userLocation
        //Zoom to user location
        let viewRegion = MKCoordinateRegionMakeWithDistance((userLocation?.coordinate)!, 50, 50)
        map.setRegion(viewRegion, animated: false)
        // Call stopUpdatingLocation() to stop listening for location updates,
        // other wise this function will be called every time when user location changes.
        
        // manager.stopUpdatingLocation()
        
        getBabysitters()
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
                                  discipline: babysitter["id"].stringValue,
                                  coordinate: CLLocationCoordinate2D(latitude: Double((babysitter["altitude"].stringValue))!, longitude: Double((babysitter["longitude"].stringValue))!))
            let bbcoordinate = CLLocation(latitude: Double((babysitter["altitude"].stringValue))!, longitude: Double((babysitter["longitude"].stringValue))!)

            let distanceInMeters = userLocation?.distance(from: bbcoordinate) // result is in meters
            if(distanceInMeters!<=rad){
                print("in range")
                annotations.append(marker)
            }
            else{
                print("not in range")
            }
            
        }
        map.addAnnotations(annotations)
        circle = MKCircle(center: (userLocation.coordinate), radius: rad)
        map.add(circle!)
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
              displayDialog()
        

    }
    func tabBarDidSelectExtraLeftItem(_ tabBar: YALFoldingTabBar) {
        let content = self.storyboard!.instantiateViewController(withIdentifier: "myPrivateOffers") as! MyOfferCollectionViewController
        self.navigationController?.pushViewController(content, animated: true)

    }
    func displayDialog() {
        let vc = FiltreViewController(nibName: "FiltreDialog", bundle: nil)
        
        
        // vc.photo.kf.setImage(with: url)        // Present dialog
        
        
        // Create the dialog
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "Accept", height: 60) {
            print(vc.getVal())
            self.rad = CLLocationDistance(vc.getVal())
            //apply filtres
            self.map.remove(self.circle!)
            self.map.removeAnnotations(self.annotations)
            self.circle = MKCircle(center: (self.userLocation.coordinate), radius: self.rad)
            self.map.add(self.circle!)
            self.populateMap()
            
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // do something
        let marker = view.annotation as! BabySitterPin
        print("Taped \(marker.discipline)")
        displayDialog(request: babysitters[0])
    }
    
    func displayDialog(request:JSON) {
        let vc = RequestDialogViewController(nibName: "RequestDialog", bundle: nil)
        vc.request = request
        
        
        // vc.photo.kf.setImage(with: url)        // Present dialog
        
        
        // Create the dialog
        let popup = PopupDialog(viewController: vc, buttonAlignment: .horizontal, transitionStyle: .bounceDown, gestureDismissal: true)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
            
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "Hire", height: 60) {
            let content = self.storyboard!.instantiateViewController(withIdentifier: "AddJob") as! AddJobViewController
            content.bbyId = request["id"].stringValue
            self.present(content, animated: true, completion: nil)
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        self.present(popup, animated: true, completion: nil)
        
        
    }


}


