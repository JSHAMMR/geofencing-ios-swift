//
//  ViewController.swift
//  Geofencing
//
//  Created by Gamil Ali Qaid Shamar on 03/11/2019.
//  Copyright © 2019 com.xchanging.agencydaiichi. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    let locationManager = CLLocationManager()
    var longGesture = UILongPressGestureRecognizer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.delegate = self
        
        
        
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 1
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        
        
        
        // stop any existing monitered region
        
        for itemRegion in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: itemRegion)
        }
        
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longGesture.minimumPressDuration = 0.5
        map.addGestureRecognizer(longGesture)
        
        
      //  self.setupCircleGeofencing(title: "test", lat: 3.116103930822632 , long: 101.63855281568493, radius: 100)

        // Do any additional setup after loading the view.
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        let touchLocation = sender.location(in: map)
        let locationCoordinate = map.convert(touchLocation, toCoordinateFrom: map)
        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        
        chooseAlert(withTitle: "IMPORT", message: "PLEASE CHOOSE GEOFENCING TYPE", lat:locationCoordinate.latitude ,long: locationCoordinate.longitude)
        
        
        print("")
    }
    
    func circleAlert (withTitle title: String?, message: String?, lat : Double , long : Double) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input region title .."
        })
        
        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input region radius .."
        })
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            //
            //            if let title = alert.textFields?[0].text {
            //                print("title: \(title)")
            //            }
            
            let titleAlert = alert.textFields?[0].text
            let radiusAlert = alert.textFields?[1].text
            
            
            
            
            
            self.setupCircleGeofencing(title: titleAlert!, lat: lat, long: long, radius: Double(radiusAlert as! String) as! Double)
            
            
        }))
        
        self.present(alert, animated: true)
    }
    
    
    func chooseAlert(withTitle title: String?, message: String?, lat : Double , long : Double) {
        
        
       
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let circle = UIAlertAction(title: "CIRCLE", style: .default, handler: { action in
                
                self.circleAlert(withTitle: "CIRCLE", message: "PLEASE ENTER REGION TITLE AND RADIUS \n lat : \(lat) \n long:\(long)", lat: lat, long: long)
            })
            let polygon = UIAlertAction(title: "POLYGON", style: .default, handler: { action in
                
                
            })
            
            alert.addAction(circle)
            alert.addAction(polygon)
            
            present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
    
    func setupCircleGeofencing(title: String, lat:Double ,long:Double, radius:Double ) {
        

        
                // startMonitoring
                
                let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                locationManager.startMonitoring(for: region(with: location,radius: radius))
                
                // add annotation
                
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = title
                map.addAnnotation(annotation)
                
                
                // show overlay
        
                
                let circle = MKCircle(center: location,
                                      radius: radius)
                map.addOverlay(circle)
     
     
        
        
    }
    
    func region(with coordinate2D: CLLocationCoordinate2D ,radius: Double ) -> CLCircularRegion {
        let region = CLCircularRegion(center: coordinate2D, radius: radius, identifier: randomString(length: 10))
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    @IBAction func locate(_ sender: Any) {
        map.zoom()
        
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }


}


var routIndex = 1

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        map.showsUserLocation = status == .authorizedAlways
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Manager failed with the following error: \(error)")
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {

        self.title = "CHECK IN"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)

        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.title = "CHECK OUT"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        
        
        // zoom to currenuser location
        map.zoom()

        // print demo routing ....
        
        
        
        
        /*
         print("<wpt lat=\"\(Double((locations.last?.coordinate.latitude)!))\" lon=\"\(Double((locations.last?.coordinate.longitude)!))\">")
        
        print("<name>WP\(routIndex)</name>")
        
        print("<time>\(Date())</time>")
        
        
        print("</wpt>")
        routIndex = routIndex + 1
        */
        
        
        /////////////
        
        
        
        
        
        
   // print("longitude \(Double((locations.last?.coordinate.longitude)!))\nlatitude \(Double((locations.last?.coordinate.latitude)!))")

        
    }
    
    
    
    
}

extension ViewController:UIGestureRecognizerDelegate {
    
}
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView,
                 rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let circleOverlay = overlay as? MKCircle {
            let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
            circleRenderer.fillColor = .red
            circleRenderer.alpha = 0.5
            
            return circleRenderer
        }

        return MKOverlayRenderer(overlay: overlay)
        
    }
}
