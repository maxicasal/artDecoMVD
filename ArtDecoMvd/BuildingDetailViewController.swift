//
//  BuildingDetailViewController.swift
//  ArtDecoMvd
//
//  Created by Gabriela Peluffo on 8/26/16.
//  Copyright © 2016 Gabriela Peluffo. All rights reserved.
//

import UIKit
import MapKit
import XLMediaZoom

class BuildingDetailViewController: UIViewController {
    
    @IBOutlet var buildingImage: UIImageView!
    @IBOutlet var buildingTitleLabel: UILabel!
    @IBOutlet var buildingArchitectLabel: UILabel!
    @IBOutlet var buildingMapView: MKMapView!
    @IBOutlet var buildingAddressLabel: UITextView!
    @IBOutlet var buildingAboutText: UITextView!
    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var buildingUseLabel: UILabel!
    @IBOutlet var buildingImageRatioConstraint: NSLayoutConstraint!
    @IBOutlet var buildingImageHeightConstraint: NSLayoutConstraint!
    

    var building: Building?
    var isFavorite : Bool = false
    let reuseIdentifier = "pin"

    override func viewDidLoad() {
        super.viewDidLoad()
        buildingMapView.delegate = self
        initializeLayout()
        setupTapGestureToImageView()
    }

    func initializeLayout() {

        if let building = self.building {
            setupImage()
            setupInformation(building)

            // favorite star
            isFavorite = Favorites.sharedInstance.isFavorite(building: building)
            favoriteButton.setImage(UIImage(named: isFavorite ? Images.favorite : Images.notFavorite), for: .normal)

            // map pin
            addAnnotation(building: building)
        }

    }
    
    func setupImage() {
        if let image = self.building!.image {
            if image == Images.noImage {
                buildingImage.frame.size.height = 0
                buildingImageRatioConstraint.isActive = false
                buildingImageHeightConstraint.constant = 0
            } else {
                buildingImage.image = UIImage(named: image)
                buildingImageHeightConstraint.isActive = false
            }
            
        } else {
            buildingImage.frame.size.height = 0
            buildingImageRatioConstraint.isActive = false
            buildingImageHeightConstraint.constant = 0
        }
    }
    
    func setupInformation(_ building: Building) {
        // title
        buildingTitleLabel.text = building.name.uppercased()
        super.title = building.name
        
        // year - architect
        if building.year != "" {
            buildingArchitectLabel.text = "\(building.year)"
        }
        
        if building.architect != "" {
            buildingArchitectLabel.text = buildingArchitectLabel.text! + " - \(building.architect)"
        }
        
        buildingArchitectLabel.font = UIFont(name: kFontLight, size: 15)
        
        // address
        buildingAddressLabel.text = building.address
        
        // program
        if let program = building.program {
            buildingUseLabel.text = program
            buildingUseLabel.font = UIFont(name: kFontLight, size: 14)
        }
        
        // description
        buildingAboutText.text = building.fullDescription
        buildingUseLabel.font = UIFont(name: kFontLight, size: 14)
    }

    @IBAction func toggleFavorite(sender: AnyObject) {
        if let building = self.building {
            Favorites.sharedInstance.toggleFavorite(building: building)
            isFavorite = !isFavorite
            favoriteButton.setImage(UIImage(named: isFavorite ? Images.favorite : Images.notFavorite), for: .normal)
        }
    }

    func setupTapGestureToImageView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(BuildingDetailViewController.imageTapped))

        buildingImage.isUserInteractionEnabled = true
        buildingImage.addGestureRecognizer(tapGestureRecognizer)

    }



    @objc func imageTapped() {
        let imageZoom = XLMediaZoom(animationTime: 0.5, image: buildingImage, blurEffect: true)
        let screenSize: CGRect = UIScreen.main.bounds
        imageZoom!.center = CGPoint(x: screenSize.width/2, y: screenSize.height/2)
        view.addSubview(imageZoom!)
        imageZoom!.show()
    }
}

extension BuildingDetailViewController: MKMapViewDelegate{

    func addAnnotation(building:Building){

        let annotation = BuildingPinAnnotation()
        annotation.title = building.name
        annotation.subtitle = building.address
        annotation.coordinate = building.location

        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        buildingMapView.addAnnotation(annotationView.annotation!)

        let regionRadius: CLLocationDistance = 200
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        buildingMapView.setRegion(coordinateRegion, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var auxView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if(auxView == nil) {
            auxView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            auxView!.canShowCallout = false
            auxView!.calloutOffset = CGPoint(x: -5, y: 5)
            auxView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            auxView!.image = UIImage(named: Images.mapPinDetails)
        } else {
            auxView!.annotation = annotation
        }

        return auxView
    }
}
