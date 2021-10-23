//
//  PlacesTableViewController.swift
//  FoursquareClone
//
//  Created by Ömer Faruk KÖSE on 22.10.2021.
//

import UIKit
import Parse

class PlacesViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var placesNameArray = [String]()
    var placesIdArray = [String]()
    var selectedObjectId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Log Out", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logOutButtonClicked))
        
        getDataFromParse()
    }
    
    func getDataFromParse(){
        let query = PFQuery(className: "Places") //Places sınıfından sorgula
        query.findObjectsInBackground { (objects, error) in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            } else {
                if objects != nil {
                    self.placesIdArray.removeAll(keepingCapacity: false)  // Arrayi sil ama uzunluğunu sakla
                    self.placesNameArray.removeAll(keepingCapacity: false)
                    
                    for object in objects! {
                        if let placeName = object.object(forKey: "name") as? String { // ÖNEMLİ SATIR ----------
                            if let placeId = object.objectId {
                                self.placesNameArray.append(placeName)
                                self.placesIdArray.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placesNameArray[indexPath.row]
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPlacesDetailsVC" {
            let destination = segue.destination as? DetailsViewController
            destination?.chosenObjectId = selectedObjectId
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedObjectId = placesIdArray[indexPath.row]
        performSegue(withIdentifier: "toPlacesDetailsVC", sender: nil)
    }
    
    @objc func addButtonClicked(){
        performSegue(withIdentifier: "toPlacesInfoVC", sender: nil)
    }
    
    @objc func logOutButtonClicked(){
        PFUser.logOutInBackground { error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Log Out Error !")
            }else{
                self.performSegue(withIdentifier: "toSignVC", sender: nil)
            }
        }
    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

}
