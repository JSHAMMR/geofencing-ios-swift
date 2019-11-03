//
//  ViewController.swift
//  Geofencing
//
//  Created by Gamil Ali Qaid Shamar on 03/11/2019.
//  Copyright © 2019 com.xchanging.agencydaiichi. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var map: MKMapView!
    fileprivate let locationManager = CLLocationManager()
    private var longGesture = UILongPressGestureRecognizer()
    fileprivate var status:String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // notification setup
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert]) {
            (granted, error) in
            if granted {
                print("yes")
            } else {
                print("No")
            }
        }
        
        
        /// map delegate
        
        map.delegate = self
        
        
        
        
        // locationManager
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.distanceFilter = 1
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        
        
        // stop any existing monitered region
        
        for itemRegion in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: itemRegion)
        }
        
        
        // add Gesture to get touch Location on map
        
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        longGesture.minimumPressDuration = 0.5
        map.addGestureRecognizer(longGesture)
        
        
      //  self.setupCircleGeofencing(title: "test", lat: 3.116103930822632 , long: 101.63855281568493, radius: 100)

        // Do any additional setup after loading the view.
    }
    
    func scheduleNotification(title: String, body: String) {
        
        let content = UNMutableNotificationContent()
        
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false) // send notification in 0.1 sec
        let request = UNNotificationRequest(identifier: randomString(length: 10), content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
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
        
        
        if polygonCoordinate.count >  0 { // must be 2 coords or more
            self.polygonAlert(withTitle: "POLYGON", message: "ADDING TO POLYGON SHAPE \n lat : \(lat) \n long:\(long)", lat: lat, long: long)
            
        } else {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let circle = UIAlertAction(title: "CIRCLE", style: .default, handler: { action in
                self.polygonCoordinate.removeAll()
                self.circleAlert(withTitle: "CIRCLE", message: "PLEASE ENTER REGION TITLE AND RADIUS \n lat : \(lat) \n long:\(long)", lat: lat, long: long)
            })
            let polygon = UIAlertAction(title: "POLYGON", style: .default, handler: { action in
                self.polygonCoordinate.removeAll()

                 self.polygonAlert(withTitle: "POLYGON", message: "ADDING TO POLYGON SHAPE \n lat : \(lat) \n long:\(long)", lat: lat, long: long)
            })
            
            alert.addAction(circle)
            alert.addAction(polygon)
            
            present(alert, animated: true, completion: nil)
        
        
        }
        
    }
    
    
    

    func setupCircleGeofencing(title: String, lat:Double ,long:Double, radius:Double ) {
        
        
        
        
        // remove all existing overlay
        
        self.map.removeOverlays(self.map.overlays)

        
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
    
    func setupPolygonGeofencing(title: String, lat:Double ,long:Double) {
        
        
        
        // remove all existing overlay
        
        self.map.removeOverlays(self.map.overlays)

        
        // add annotation

        
        let annotation = MKPointAnnotation()
        annotation.coordinate = self.polygonCoordinate[0]
        annotation.title = title
        map.addAnnotation(annotation)
        
        
        // show overlay
        
        
        
        
       let polygon = MKPolygon(coordinates: self.polygonCoordinate, count: self.polygonCoordinate.count)
        
        
        map.addOverlay(polygon)
        
        
        
        
    }
    
    var polygonCoordinate = [CLLocationCoordinate2D]()

    func polygonAlert (withTitle title: String?, message: String?, lat : Double , long : Double) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        var titleStr : String!
        
        
        
        if polygonCoordinate.count >= 3 { // must be 3 coords or more
            alert.addTextField(configurationHandler: { textField in
                textField.placeholder = "Input region title .."
            })
            
            titleStr = "Save"
            
        } else {
            titleStr = "Add"
            
        }
        

        
        alert.addAction(UIAlertAction(title: titleStr, style: .default, handler: { action in
            if self.polygonCoordinate.count >= 3 { // must be 2 coords or more
                self.polygonCoordinate.append(CLLocationCoordinate2D(latitude: lat, longitude: long))
                let titleAlert = alert.textFields?[0].text
                
                
           
                
                self.setupPolygonGeofencing(title: titleAlert!, lat: lat, long: long)
                
                
            } else {
                
                self.polygonCoordinate.append(CLLocationCoordinate2D(latitude: lat, longitude: long))
                
            }
            
        }))
        
        self.present(alert, animated: true)
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
        
        scheduleNotification(title: "CHECK IN", body: "You already enter the geofencing region ..! ")
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.title = "CHECK OUT"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        scheduleNotification(title: "CHECK OUT", body: "You already exite the geofencing region ..! ")

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
        
        
        
        // for polygon
        
        
        
        if polygonCoordinate.count > 0 { // means the polygon has been chosen
            let point = CLLocationCoordinate2D(latitude: (locations.last?.coordinate.latitude)!, longitude: (locations.last?.coordinate.longitude)!)
            
            let path = GMSMutablePath()
            self.polygonCoordinate.forEach({
                
                
                path.add($0)
            })
            
            if GMSGeometryContainsLocation(point, path, false) {
                print("inside")
                
                if status != "CHECK IN" {
                    //self.scheduleNotification(notificationType: "CHECK IN")
                }
                
                status = "CHECK IN"
                self.title = status
                navigationController?.navigationBar.barTintColor = UIColor.green
                
                scheduleNotification(title: "CHECK IN", body: "You already enter the geofencing region ..! ")

                
            } else {
                
                if status != "CHECK OUT" {
                    // self.scheduleNotification(notificationType: "CHECK OUT")
                    
                }
                
                status = "CHECK OUT"
                self.title = status
                navigationController?.navigationBar.barTintColor = UIColor.red
                scheduleNotification(title: "CHECK OUT", body: "You already exite the geofencing region ..! ")

                print("outside")
            }
            
        }
        
       

        
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
        if let polygonOverlay = overlay as? MKPolygon {
            let polygonRenderer = MKPolygonRenderer(overlay: polygonOverlay)
            polygonRenderer.fillColor = .red
            polygonRenderer.alpha = 0.5
            
            return polygonRenderer
        }

        return MKOverlayRenderer(overlay: overlay)
        
    }
}
