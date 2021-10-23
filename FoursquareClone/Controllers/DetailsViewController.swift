//
//  PlacesDetailsViewController.swift
//  FoursquareClone
//
//  Created by Ömer Faruk KÖSE on 23.10.2021.
//

import UIKit
import MapKit
import Parse

class DetailsViewController: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeTypeLabel: UILabel!
    @IBOutlet weak var placeNoteLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var chosenObjectId = ""
    var chosenLatitude = Double()
    var chosenLongitude = Double()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        getDataFromParseWidthObjectId()
    }
    
    func getDataFromParseWidthObjectId(){
        let query = PFQuery(className:"Places")
        query.whereKey("objectId", equalTo: chosenObjectId)
        query.findObjectsInBackground { (objects , error) in
            if error != nil {
                // Log details of the failure
                print(error?.localizedDescription)
            } else if objects != nil && objects!.count > 0 {
                
                let object = objects![0]
                
                if let placeName = object.object(forKey: "name") as? String { // ÖNEMLİ SATIR ----------
                    self.placeNameLabel.text = placeName
                }
                if let placeType = object.object(forKey: "type") as? String { // ÖNEMLİ SATIR ----------
                    self.placeTypeLabel.text = placeType
                }
                if let placeNote = object.object(forKey: "note") as? String { // ÖNEMLİ SATIR ----------
                    self.placeNoteLabel.text = placeNote
                }
                if let latitude = object.object(forKey: "latitude") as? String { // ÖNEMLİ SATIR ----------
                    if let getLatitude = Double(latitude) {
                        self.chosenLatitude = getLatitude
                    }
                }
                if let longitude = object.object(forKey: "longitude") as? String { // ÖNEMLİ SATIR ----------
                    if let getLongitude = Double(longitude) {
                        self.chosenLongitude = getLongitude
                    }
                }
                if let imageData = object.object(forKey: "image") as? PFFileObject {
                    imageData.getDataInBackground { (data, error) in
                        if error == nil {
                            if data != nil {
                            self.imageView.image = UIImage(data: data!)
                            }
                        }
                    }
                }
                
                // MAP
                
                let location = CLLocationCoordinate2D(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
                
                let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
                
                let region = MKCoordinateRegion(center: location, span: span)
                
                self.mapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = self.placeNameLabel.text!
                annotation.subtitle = self.placeTypeLabel.text!
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
        } else {
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenLatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenLatitude, longitude: self.chosenLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    
                    if placemark.count > 0 {
                        
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.placeNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                    
                }
            }
            
        }
    }

}
