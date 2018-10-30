//
//  EdificiosViewController.swift
//  ArtDecoMvd
//
//  Created by Gabriela Peluffo on 8/25/16.
//  Copyright © 2016 Gabriela Peluffo. All rights reserved.
//

import UIKit

class BuildingListViewController: UIViewController {

    private enum TableOption : Int{
        case ByBuilding = 0
        case ByAuthor   = 1
    }

    @IBOutlet var optionsTabView: UIView!
    @IBOutlet var buildingFilter: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var thisView: UIView!
    @IBOutlet var searchButton: UIBarButtonItem!
    @IBOutlet var buildingGroupOptions: UISegmentedControl!
    @IBOutlet var buildingGroupOptionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet var buildingGroupOptionView: UIView!
    
    let buildingCellIdentifier      = "BuildingCell"
    
    private var filteredBuildings     : [Building] = []
    private var buildingsList         : [Building] = []
    private var buildingsByAuthor     : [String:[Building]]?
    private var buildingsByAuthorKeys : [String] = []
    private var builingListType       : TableOption = TableOption.ByBuilding
    
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad();

        setupBuildingsUI()
        setupSearchController()

        // load buildings
//        buildingsList = Building.loadBuildings().sort({ $0.name < $1.name })
        buildingsByAuthor = groupBuildingsByAuthor()

        tableView.delegate = self
        tableView.dataSource = self

    }


//  -----------------------   events     ---------------------------------

    @IBAction func showSearchBar(sender: AnyObject) {
        toggleSearchBar(hide: false)
    }

    func toggleSearchBar(hide: Bool){
        let frame : CGRect = hide ? CGRect(x: 0, y: 0, width: 320, height: 0) : CGRect(x: 0, y: 0, width: 320, height: 44)

        UIView.animate(withDuration: 0.3) {
            self.searchController.searchBar.frame = frame
            self.tableView.tableHeaderView = hide ? nil : self.searchController.searchBar
        }

        buildingGroupOptionsHeightConstraint.constant = hide ? 55 : 0
        tableView.setContentOffset(CGPoint.zero, animated:true)

    }

    @IBAction func buildingGroupOptionValueChanged(sender: UISegmentedControl) {
        builingListType = TableOption(rawValue: sender.selectedSegmentIndex)!
        tableView.reloadData()
    }


//  -----------------------   layout     ---------------------------------

    private func setupSearchController() {
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = Colors.mainColor
        searchController.searchBar.barTintColor = Colors.mainColor
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.delegate = self

        //SearchBar Text
        let textFieldInsideUISearchBar = searchController.searchBar.value(forKey: "searchField") as? UITextField

        //SearchBar Placeholder
        let textFieldInsideUISearchBarLabel = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideUISearchBarLabel?.text = "Buscar"
        textFieldInsideUISearchBarLabel?.font = UIFont(name: kFontLight, size: 14)

        searchController.searchBar.setValue("Cancelar", forKey:"_cancelButtonText")
        self.extendedLayoutIncludesOpaqueBars = true;

    }

    private func setupBuildingsUI() {
        buildingGroupOptionView.backgroundColor = Colors.mainColor
        buildingGroupOptions.backgroundColor = Colors.mainColor
        buildingGroupOptions.setTitleTextAttributes(Fonts.segmentedControlFont, for: .normal)
    }


}

extension BuildingListViewController : UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        //ToDo
    }
    

    //--------------------------------------------------------------------------------------
    //                                  SEARCH BAR
    //--------------------------------------------------------------------------------------

    func filterContentForSearchText(searchText: String, scope: String = "All") {
        if searchText == "" {
            filteredBuildings = buildingsList
        } else {
            filteredBuildings = buildingsList.filter { building in
                return building.name.lowercased().range(of: searchText.lowercased()) != nil || (building.architect.lowercased().range(of: searchText.lowercased()) != nil)
            }
        }

        tableView.reloadData()
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchText: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        toggleSearchBar(hide: true)
    }

    func isSearch() -> Bool {
        return searchController.isActive && searchController.searchBar.text != ""
    }
}



extension BuildingListViewController: UITableViewDelegate, UITableViewDataSource {

    //--------------------------------------------------------------------------------------
    //                                  TABLE SECTIONS
    //--------------------------------------------------------------------------------------

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if isSearch() {
            return filteredBuildings.count
        }else if builingListType == TableOption.ByBuilding {
            return buildingsList.count
        }else{
            let key = buildingsByAuthorKeys[section]
            return (buildingsByAuthor![key]?.count)!
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return isSearch() ? 1 : (builingListType == TableOption.ByBuilding ? 1 : buildingsByAuthor!.keys.count)
    }


    //--------------------------------------------------------------------------------------
    //                                  TABLE HEADER
    //--------------------------------------------------------------------------------------

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if !isSearch() && builingListType == TableOption.ByAuthor {
            return 30
        }
        return 0
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !isSearch() && builingListType == TableOption.ByAuthor {
            return buildingsByAuthorKeys[section].uppercased()
        }
        return ""
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel!.textColor = Colors.mainColor50
        header.textLabel!.font = UIFont(name: kFontMedium, size: 14)
        header.textLabel!.frame = header.frame
    }

    //--------------------------------------------------------------------------------------
    //                                  TABLE CELLS
    //--------------------------------------------------------------------------------------

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: buildingCellIdentifier, for: indexPath as IndexPath) as! BuildingTableViewCell
        
        cell.configure(building: getBuildingByIndexPath(indexPath: indexPath as NSIndexPath))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let building = getBuildingByIndexPath(indexPath: indexPath as NSIndexPath)
        
        if let image = building.image {
            return CGFloat(image == Images.noImage ? kBuildingCellHeightNoImage : kBuildingCellHeight)
        } else {
            return CGFloat(kBuildingCellHeightNoImage)
        }
    }

}

extension BuildingListViewController{

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let buildindDetailViewController = segue.destination as? BuildingDetailViewController
        {
            buildindDetailViewController.building = getBuildingByIndexPath(indexPath: indexPath as NSIndexPath)
        }
    }

    func getBuildingByIndexPath(indexPath:NSIndexPath) -> Building{

        if isSearch() {
            return filteredBuildings[indexPath.row]
        }else if builingListType == TableOption.ByBuilding {
            return buildingsList[indexPath.row]
        }else{
            let key = buildingsByAuthorKeys[indexPath.section]
            return buildingsByAuthor![key]![indexPath.row]
        }
    }

    private func groupBuildingsByAuthor() -> [String:[Building]]{
        var list = [String:[Building]]()

        for building in buildingsList {
            let key = building.architect == "" ? "Otros" : building.architect

            if !list.keys.contains(key){
                list[key] = []
            }

            list[key]?.append(building)
        }

        buildingsByAuthorKeys = Array(list.keys)
//        buildingsByAuthorKeys.sortInPlace({
//            $0 < $1 || $1 == "Otros"
//        })

        _ = buildingsByAuthorKeys.map { (key) in
            list[key]!.sort(by: { $0.name < $1.name })
        }
        return list
    }
}
