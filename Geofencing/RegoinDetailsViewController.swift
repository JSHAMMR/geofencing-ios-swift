
//
//  RegoinDetailsViewController.swift
//  Geofencing
//
//  Created by Gamil Ali Qaid Shamar on 04/11/2019.
//  Copyright © 2019 com.xchanging.agencydaiichi. All rights reserved.
//

import UIKit
import RealmSwift
import MapKit

class RegionDetailsViewControllerCell: UITableViewCell {
    
    @IBOutlet weak var lat: UILabel!
    
    @IBOutlet weak var long: UILabel!
}
class RegionDetailsViewController: UIViewController {

    @IBOutlet weak var radiusTxtFld: UITextField!

    @IBOutlet weak var map: MKMapView!
    var regionId = ""
    let realm = try! Realm()
    fileprivate var regionObject:RegionObject!
    fileprivate var coordinatesObject:  Results<CoordinatesObject>!

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Region Details"
hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    @IBAction func update(_ sender: Any) {
        
        let regionObjectT = RegionObject()
        regionObjectT.id = regionObject.id
        regionObjectT.title = regionObject.title
        regionObjectT.type = regionObject.type
        regionObjectT.radius = Double(radiusTxtFld.text as! String) as! Double
        
        try! self.realm.write {
            self.realm.add(regionObjectT, update: true)
        }
        
        getRegion()

        
       // self.navigationController?.popViewController(animated: true)
        
    }
    
    
    
    func drawOverlays() {
        if regionObject.type == "circle" {
            
            
            
            
            
            
            if coordinatesObject.count > 0 {
                
                
                let location = CLLocationCoordinate2D(latitude: coordinatesObject[0].latitude, longitude: coordinatesObject[0].longitude)
                
                let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
                map.setRegion(region, animated: true)
                
                
                
                
                
                
                // add annotation
                
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = regionObject.title
                map.addAnnotation(annotation)
                
                
                // show overlay
                
                
                let circle = MKCircle(center: location,
                                      radius: regionObject.radius)
                map.addOverlay(circle)
                
                
                
            }
            
        }
        
        
        if regionObject.type == "polygon" {
            
            
            
            
            
            
            if coordinatesObject.count > 0 {
                
              
                let location = CLLocationCoordinate2D(latitude: coordinatesObject[0].latitude, longitude: coordinatesObject[0].longitude)
                
                let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
                map.setRegion(region, animated: true)
                
                
                
                
                
                
                // add annotation
                
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = regionObject.title
                map.addAnnotation(annotation)
                
                
                // show overlay
                
                var polygonCoordinate = [CLLocationCoordinate2D]()
                
                coordinatesObject.forEach({
                    
                    polygonCoordinate.append(CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))
                    
                })
                
                let polygon = MKPolygon(coordinates: polygonCoordinate, count: polygonCoordinate.count)
                
                
                map.addOverlay(polygon)
                
                
                
                
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      
        getRegion()
    }
    
    
    func getRegion () {
        regionObject = realm.objects(RegionObject.self).filter("id = '\(regionId)'").first
        coordinatesObject = realm.objects(CoordinatesObject.self).filter("regionId = '\(regionObject.id)'")
        
        radiusTxtFld.text = "\(regionObject.radius)"
        self.map.removeOverlays(self.map.overlays)
        
        self.map.removeAnnotations(self.map.annotations)
        
        drawOverlays()
        self.tableView.reloadData()
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RegionDetailsViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coordinatesObject.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionDetailsViewControllerCell", for: indexPath) as! RegionDetailsViewControllerCell
        
        
        
        
        cell.lat.text = "\(coordinatesObject[indexPath.row].latitude)"
        cell.long.text = "\(coordinatesObject[indexPath.row].longitude)"

        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
       
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        
        let coordinatesViewController = storyboard.instantiateViewController(withIdentifier: "CoordinatesViewController") as? CoordinatesViewController
        
        coordinatesViewController?.coordinateId = coordinatesObject[indexPath.row].id
        self.navigationController?.pushViewController(coordinatesViewController!, animated: true)
        
        
        
        
        
        
        
    }
    
    
    
}
extension RegionDetailsViewController: MKMapViewDelegate {
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
