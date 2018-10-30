//
//  LocationSearchTableViewController.swift
//  ArtDecoMvd
//
//  Created by Gabriela Peluffo on 10/26/16.
//  Copyright © 2016 Gabriela Peluffo. All rights reserved.
//

import UIKit
import MapKit

protocol LocationSearchDelegate {
    func buildingSelected(building:Building)
}

class LocationSearchTableViewController : UITableViewController {

    var matchingBuildings : [Building] = []
    var buildingsList     : [Building] = []
    var delegate          : LocationSearchDelegate!

    override func viewDidLoad() {
        buildingsList = Building.loadBuildings()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingBuildings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        let building = matchingBuildings[indexPath.row]
        
        cell.textLabel!.text = building.name
        cell.detailTextLabel!.text = building.address
        
        cell.textLabel?.font = UIFont(name: kFontMedium, size: 17)
        cell.detailTextLabel?.font = UIFont(name: kFontLight, size: 14)
        
        return cell
    }


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            let building = matchingBuildings[indexPath.row]
            dismiss(animated: true, completion: nil)
            delegate.buildingSelected(building: building)
        }
    }

}

extension LocationSearchTableViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            matchingBuildings = []
        } else {
            matchingBuildings = buildingsList.filter { building in
                let searchTextLower = searchController.searchBar.text!.lowercased()
                return building.name.lowercased().range(of: searchTextLower) != nil ||
                    building.address.lowercased().range(of: searchTextLower) != nil
            }
        }

        tableView.reloadData()
    }
}
