//
//  PlacesInfoViewController.swift
//  FoursquareClone
//
//  Created by Ömer Faruk KÖSE on 23.10.2021.
//

import UIKit

class InfoViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var placeNameField: UITextField!
    @IBOutlet weak var placeTypeField: UITextField!
    @IBOutlet weak var placeNoteField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
    }
    
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.isEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if placeNameField.text != "" && placeTypeField.text != "" && placeNoteField.text != "" {
            if let chonseImage = imageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameField.text!
                placeModel.placeType = placeTypeField.text!
                placeModel.placeNote = placeNoteField.text!
                placeModel.placeImage = chonseImage
                performSegue(withIdentifier: "toPlacesMapVC", sender: nil)
            }
        }else{
            makeAlert(title: "Error !", message: "Enter Place , name & type & note." )
        }
        

    }
    
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    

}
