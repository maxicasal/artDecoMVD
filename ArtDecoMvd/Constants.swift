//
//  Constants.swift
//  ArtDecoMvd
//
//  Created by Gabriela Peluffo on 8/21/16.
//  Copyright © 2016 Gabriela Peluffo. All rights reserved.
//

import UIKit

let kBuildingsKey  = "Buildings"
let kFontLight     = "Avenir-Light"
let kFontMedium    = "Avenir-Medium"
let kFontRegular   = "Avenir"
let kFontHeavy     = "Avenir-Heavy"

let kBuildingCellHeight        = 158
let kBuildingCellHeightNoImage = 158

struct Colors {

    static let mainColor    : UIColor = UIColor(red: 40/255, green: 59/255, blue: 105/255, alpha: 1)
    static let mainColor50  : UIColor = UIColor(red: 40/255, green: 59/255, blue: 105/255, alpha: 0.5)
    static let grey         : UIColor = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1)
}

struct Fonts {

    static let navBarFont = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: kFontMedium, size: 17)!]

    static let segmentedControlFont = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: kFontLight, size: 14)!]
}

struct Images{
    static let noImage            = "no_image"
    static let builgingDefault    = "building_default"
    static let favorite           = "fav_selectedx2"
    static let notFavorite        = "favx2"
    static let favoriteSmaller    = "fav_selected"
    static let notFavoriteSmaller = "fav"
    static let mapFavorite        = "map_pin_favorite"
    static let mapNotFavorite     = "map_pin"
    static let mapPinDetails      = "details_map_pin"
}
