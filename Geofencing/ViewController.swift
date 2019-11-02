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
        locationManager.distanceFilter = 5
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longGesture.minimumPressDuration = 0.5
        map.addGestureRecognizer(longGesture)
        
        
        self.setupCircleGeofencing(title: "test", lat: 3.116103930822632 , long: 101.63855281568493, radius: 100)

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
        let region = CLCircularRegion(center: coordinate2D, radius: radius, identifier: "justIdentifier")
        region.notifyOnEntry = true
        region.notifyOnExit = true
        return region
    }
    
    @IBAction func locate(_ sender: Any) {
        map.zoom()
        
    }


}

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
        print("enter")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("exit")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
    print("longitude \(Double((locations.last?.coordinate.longitude)!))\nlatitude \(Double((locations.last?.coordinate.latitude)!))")

        
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
