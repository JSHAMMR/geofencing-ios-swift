//
//  RegionsViewController.swift
//  Geofencing
//
//  Created by Gamil Ali Qaid Shamar on 04/11/2019.
//  Copyright © 2019 com.xchanging.agencydaiichi. All rights reserved.
//

import UIKit
import RealmSwift

class RegionsViewControllerCell:UITableViewCell {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var type: UILabel!
    
}

class RegionsViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let cellId = "RegionsViewControllerCell"
    let realm = try! Realm()
    fileprivate var userRegions:  Results<RegionObject>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Regions"

        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        userRegions = realm.objects(RegionObject.self).sorted(byKeyPath: "created", ascending: false)
        userRegions.forEach({print($0.title)})
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

extension RegionsViewController :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRegions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionsViewControllerCell", for: indexPath) as! RegionsViewControllerCell
        
        
        
        
        cell.title.text = userRegions[indexPath.row].title
        cell.type.text = userRegions[indexPath.row].type

        return cell

    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        
        let regionDetailsViewController = storyboard.instantiateViewController(withIdentifier: "RegionDetailsViewController") as? RegionDetailsViewController
        
        regionDetailsViewController?.regionId = userRegions[indexPath.row].id
        self.navigationController?.pushViewController(regionDetailsViewController!, animated: true)
        
        
        
        
        
        
        
    }
    
    
}
