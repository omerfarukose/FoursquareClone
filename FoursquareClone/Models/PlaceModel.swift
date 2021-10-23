//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Ömer Faruk KÖSE on 23.10.2021.
//

import Foundation
import UIKit

class PlaceModel{
    
    static let sharedInstance = PlaceModel()
    
    var placeName = ""
    var placeType = ""
    var placeNote = ""
    var placeLatitude = ""
    var placeLongitude = ""
    var placeImage = UIImage()
    private init(){}
    
}
