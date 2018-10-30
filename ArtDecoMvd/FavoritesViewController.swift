//
//  FavoritesViewController.swift
//  ArtDecoMvd
//
//  Created by Gabriela Peluffo on 8/26/16.
//  Copyright © 2016 Gabriela Peluffo. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class FavoritesViewController: UIViewController{

    @IBOutlet var thisView: UIView!
    @IBOutlet var tableView: UITableView!
    
    var favorites : [Building] = []
    let favoriteCell = "FavCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        thisView.backgroundColor = Colors.mainColor
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()

        initializeFavorites()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initializeFavorites()
        tableView.reloadData()
    }
    
    func initializeFavorites() {
//        favorites = Building.loadBuildings()
//            .filter{ building in
//                return Favorites.sharedInstance.isFavorite(building: building)
//            }.sort({
//                $0.name < $1.name
//            })
    }
    
}

extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: favoriteCell, for: indexPath) as! BuildingTableViewCell
        
        cell.configure(building: favorites[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let building = favorites[indexPath.row]
        
        if let image = building.image {
            return CGFloat(image == Images.noImage ? kBuildingCellHeightNoImage : kBuildingCellHeight)
        } else {
            return CGFloat(kBuildingCellHeightNoImage)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell),
            let buildindDetailViewController = segue.destination as? BuildingDetailViewController
        {
            buildindDetailViewController.building = favorites[indexPath.row]
        }
    }
}

extension FavoritesViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{

    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "star")
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No tiene favoritos"
        let attribs = [
            NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),
            NSAttributedStringKey.foregroundColor: UIColor.darkGray
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Puede marcar sus edificios favoritos desde el mapa o el listado"
        
        let para = NSMutableParagraphStyle()
        para.lineBreakMode = NSLineBreakMode.byWordWrapping
        para.alignment = NSTextAlignment.center
        
        let attribs = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
            NSAttributedStringKey.foregroundColor: UIColor.lightGray,
            NSAttributedStringKey.paragraphStyle: para
        ]
        
        return NSAttributedString(string: text, attributes: attribs)
    }

}
