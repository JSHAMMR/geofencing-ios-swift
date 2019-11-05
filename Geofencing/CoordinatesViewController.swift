//
//  CoordinatesViewController.swift
//  Geofencing
//
//  Created by Gamil Ali Qaid Shamar on 04/11/2019.
//  Copyright © 2019 com.xchanging.agencydaiichi. All rights reserved.
//

import UIKit
import RealmSwift

class CoordinatesViewController: UIViewController {

    @IBOutlet weak var latTxtFld: UITextField!
    @IBOutlet weak var longTxtFld: UITextField!
    var coordinateId = ""
    fileprivate var coordinatesObject: CoordinatesObject!
    let realm = try! Realm()

    override func viewDidLoad() {
        
        self.title = "Update Coordinates"
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        coordinatesObject = realm.objects(CoordinatesObject.self).filter("id = '\(coordinateId)'").first

        
        latTxtFld.text = "\(coordinatesObject.latitude)"
        longTxtFld.text = "\(coordinatesObject.longitude)"
        
        

        // Do any additional setup after loading the view.
    }
    
    @IBAction func save(_ sender: Any) {
        
        
        
        
        let coordinate = CoordinatesObject()
        coordinate.id = coordinatesObject.id
        coordinate.regionId = coordinatesObject.regionId
        coordinate.latitude = Double(latTxtFld.text as! String) as! Double
        coordinate.longitude = Double(longTxtFld.text as! String) as! Double
        try! self.realm.write {
            self.realm.add(coordinate, update: true)
        }
        
        
        self.navigationController?.popViewController(animated: true)
        
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
