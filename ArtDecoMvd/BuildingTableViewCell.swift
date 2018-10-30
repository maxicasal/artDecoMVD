//
//  BuildingTableViewCell.swift
//  ArtDecoMvd
//
//  Created by Gabriela Peluffo on 8/21/16.
//  Copyright © 2016 Gabriela Peluffo. All rights reserved.
//

import UIKit

class BuildingTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var favoriteButton: UIButton!
    
    var building : Building? = nil
    var isFavorite: Bool = false

    @IBAction func favoriteClicked(sender: AnyObject) {
        isFavorite = !isFavorite
        favoriteButton.setImage(UIImage(named: isFavorite ? Images.favorite : Images.notFavorite), for: .normal)
        Favorites.sharedInstance.toggleFavorite(building: building!)
        
    }

    func configure(building:Building){
        self.building = building

        nameLabel.text = building.name

        if building.year != "" {
            descriptionLabel.text = "\(building.year)"
        }

        if building.architect != "" {
            descriptionLabel.text = descriptionLabel.text! + " - \(building.architect)"
        }
        
        nameLabel.font = UIFont(name: kFontHeavy, size: 18)
        descriptionLabel.font = UIFont(name: kFontMedium, size: 15)

        if let image = building.image{
            backgroundImageView.image = image == Images.noImage ? UIImage(named:Images.builgingDefault) : UIImage(named:image)
        } else {
            backgroundImageView.image = UIImage(named:Images.builgingDefault)
        }
        
        if(favoriteButton != nil){
            isFavorite = Favorites.sharedInstance.isFavorite(building: building)
            favoriteButton.setImage(UIImage(named: isFavorite ? Images.favorite : Images.notFavorite), for: .normal)
        }
    }
}
