//
//  Building.swift
//  ARTDeco
//
//  Created by Gabriela Peluffo on 8/21/16.
//  Copyright © 2016 Gabriela Peluffo. All rights reserved.
//

import UIKit
import MapKit

struct Building {

    private enum BuildingKeys : String {
      case Name         = "name"
      case Address      = "address"
      case ShortDesc    = "shortDescription"
      case FullDesc     = "fullDescription"
      case Year         = "year"
      case Author       = "author"
      case Coordinates  = "coordinates"
      case Latitude     = "latitude"
      case Longitude    = "longitude"
      case Image        = "image"
      case Program      = "program"
    }

    var id:              Int
    var name:            String
    var address:         String
    var fullDescription: String?
    var shortDescription:String
    var year:            String
    var architect:       String
    var location:        CLLocationCoordinate2D
    var image:           String?
    var program:         String?

    static var allBuildings : [Building] = []   


    static func loadBuildings() -> [Building]{
        if allBuildings.count > 0{
            return allBuildings
        }

        let buildingList : [String:AnyObject] = NSDictionary(contentsOfFile: Bundle.main.path(forResource: kBuildingsKey, ofType: "plist")!) as! [String:AnyObject]

        let buildings = buildingList[kBuildingsKey] as! [String:[String:AnyObject]]

        return buildings.keys.map{ (key:String) -> Building in
            let data = buildings[key]!
            return Building(
                id: Int(key)!,
                name: data[BuildingKeys.Name.rawValue] as! String,
                address: data[BuildingKeys.Address.rawValue] as! String,
                fullDescription: data[BuildingKeys.FullDesc.rawValue] as? String,
                shortDescription: "",
                year: data[BuildingKeys.Year.rawValue] as! String,
                architect: data[BuildingKeys.Author.rawValue] as! String,
                location: getCoordinates(buildingData: data[BuildingKeys.Coordinates.rawValue] as! [String : AnyObject]),
                image: data[BuildingKeys.Image.rawValue] as? String,
                program: data[BuildingKeys.Program.rawValue] as? String
            )
        }
    }

    static func getCoordinates(buildingData:[String:AnyObject]) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: (buildingData[BuildingKeys.Latitude.rawValue]!.doubleValue)!,
                                     longitude: (buildingData[BuildingKeys.Longitude.rawValue]!.doubleValue)!)
    }
    
}
