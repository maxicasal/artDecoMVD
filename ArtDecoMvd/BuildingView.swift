//
//  BuildingMapAnnotation.swift
//  ArtDecoMvd
//
//  Created by Gabriela Peluffo on 8/21/16.
//  Copyright © 2016 Gabriela Peluffo. All rights reserved.
//
import UIKit
import MapKit

protocol BuildingViewDelegate {
    func openBuildingDetails(building:Building)
    func refreshMap()
}

class BuildingView : UIView {

    @IBOutlet var image: UIImageView!
    @IBOutlet var buildingName: UILabel!
    @IBOutlet var buildingAddress: UILabel!
    @IBOutlet var favoriteButton: UIButton!

    var building: Building?
    var isFavorite: Bool = false
    var isSelected: Bool = false
    var delegate: BuildingViewDelegate!

    @IBAction func favoriteTouchUp(sender: AnyObject) {

        Favorites.sharedInstance.toggleFavorite(building: building!)

        isFavorite = !isFavorite
        favoriteButton.setImage(UIImage(named: isFavorite ? Images.favoriteSmaller : Images.notFavoriteSmaller), for: .normal)

        if delegate != nil {
            delegate.refreshMap()
        }
    }

    @IBAction func gotToDetailsTouchUpInside(sender: AnyObject) {
        goToDetails()
    }

    @IBAction func detailsTouchUp(sender: AnyObject) {
        goToDetails()
    }

    func goToDetails() {
        if delegate != nil {
            delegate.openBuildingDetails(building: building!)
        }
    }

    


    func configure(building: BuildingPinAnnotation){
        self.building = building.building
        buildingName.text    = building.title!
        buildingAddress.text = building.subtitle!

        self.layer.cornerRadius = 15

        isFavorite = building.isFavorite
        favoriteButton.setImage(UIImage(named: isFavorite ? Images.favoriteSmaller : Images.notFavoriteSmaller), for: .normal)
        favoriteButton.isUserInteractionEnabled = true

        buildingAddress.font = UIFont(name: kFontLight, size: 11)
        buildingName.font = UIFont(name: kFontMedium, size: 13)
    }
}
