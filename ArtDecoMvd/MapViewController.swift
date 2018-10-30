//
//  FirstViewController.swift
//  ARTDeco
//
//  Created by Gabriela Peluffo on 8/21/16.
//  Copyright © 2016 Gabriela Peluffo. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {

    private enum PinOptions : Int{
        case All        = 0
        case Favorties  = 1
    }

    @IBOutlet var optionsTab: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var mapOptions: UISegmentedControl!

    // --------------------    variables    ---------------------------------

    var locationManager : CLLocationManager!
    let initialLocation = CLLocation(latitude: -34.911025, longitude: -56.163031)
    var userLocationSet : Bool = false

    let regionRadius: CLLocationDistance = 1000
    let reuseIdentifier = "pin"

    var buildings : [Building] = []
    var allAnnotations : [MKAnnotation] = []

    var resultsSearchController : UISearchController? = nil

    // ----------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeLocationTracker()
        initializeSearchController()

        mapView.delegate = self
        
        buildings = Building.loadBuildings()
        addPins()

        initializeLayout()

    }

    override func viewWillAppear(_ animated: Bool) {
        refreshMapAnnotations();
    }
    
    @IBAction func pinOptionsChanged(sender: AnyObject) {
        filterAnnotations(showAll: mapOptions.selectedSegmentIndex == PinOptions.All.rawValue)
    }


    func initializeLayout() {
        self.view.backgroundColor = Colors.mainColor
        optionsTab.backgroundColor = Colors.mainColor

        mapOptions.setTitleTextAttributes( Fonts.segmentedControlFont, for: .normal)
        mapOptions.backgroundColor = Colors.mainColor
    }

    func initializeLocationTracker() {

        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.delegate = self;

        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined || status == .denied {
            locationManager.requestWhenInUseAuthorization()
        }

        locationManager.requestLocation()
        mapView.showsUserLocation = true

    }

    func initializeSearchController() {

        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTableViewController
        locationSearchTable.delegate = self

        resultsSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultsSearchController?.searchResultsUpdater = locationSearchTable
        resultsSearchController?.hidesNavigationBarDuringPresentation = false
        resultsSearchController?.dimsBackgroundDuringPresentation = true

        definesPresentationContext = true

        let searchBar = resultsSearchController?.searchBar
        configureSearchBarLayout(searchBar: searchBar)
        navigationItem.titleView = searchBar
    }

    func configureSearchBarLayout(searchBar: UISearchBar?) {
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Buscar edificio"

        searchBar?.isTranslucent = false
        let textFieldInsideSearchBar = searchBar?.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar!.textColor = UIColor.white
        textFieldInsideSearchBar!.backgroundColor = Colors.mainColor
        textFieldInsideSearchBar!.tintColor = Colors.mainColor

        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textAlignment = NSTextAlignment.left
    }
    
}


extension MapViewController {

    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func addPins() {

        var annotation      : BuildingPinAnnotation
        var annotationView  : MKAnnotationView

        for building in buildings {
            annotation = BuildingPinAnnotation()
            annotation.title = building.name
            annotation.subtitle = building.address
            annotation.coordinate = building.location
            annotation.isFavorite = Favorites.sharedInstance.isFavorite(building: building)
            annotation.building = building

            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            mapView.addAnnotation(annotationView.annotation!)
            allAnnotations.append(annotationView.annotation!)
        }
    }

    func refreshMapAnnotations() {
        allAnnotations.removeAll()

        mapView.removeAnnotations(mapView.annotations)

        addPins()
    }

    func filterAnnotations(showAll:Bool) {
        if showAll {
            mapView.addAnnotations(getAnnotationsNotFavorites())
        } else {
            mapView.removeAnnotations(getAnnotationsNotFavorites())
        }
    }

    func getAnnotationsNotFavorites() -> [MKAnnotation] {
        let annotations = allAnnotations
        let filteredAnnotations = annotations.filter({ (annotation: MKAnnotation) -> Bool in
            let buildingAnnotation = annotation as! BuildingPinAnnotation
            return !buildingAnnotation.isFavorite
        })
        return filteredAnnotations
    }
}

extension MapViewController : MKMapViewDelegate, UIGestureRecognizerDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let buildingAnnotation = annotation as! BuildingPinAnnotation
        var auxView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if (auxView == nil) {
            auxView = BuildingAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            auxView!.canShowCallout = false
        } else {
            auxView!.annotation = annotation
        }
        
        auxView!.image = UIImage(named: buildingAnnotation.isFavorite ? Images.mapFavorite : Images.mapNotFavorite)
        
        return auxView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation{
            return
        }
        
        let annotation = view.annotation! as! BuildingPinAnnotation
        let buildingView = Bundle.main.loadNibNamed("BuildingAnnotationView", owner: nil, options: nil)![0] as! BuildingView
        
        view.addSubview(buildingView)
        
        buildingView.configure(building: annotation)
        buildingView.delegate = self
        buildingView.center = CGPoint(x: view.bounds.size.width / 2, y: -buildingView.bounds.size.height * 0.72)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: BuildingAnnotationView.self) {
            for subview in view.subviews{
                subview.removeFromSuperview()
            }
        }
    }

}

extension MapViewController : BuildingViewDelegate{
    func openBuildingDetails(building: Building) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let buildingDetailViewController: BuildingDetailViewController = storyboard.instantiateViewController(withIdentifier: "buildingDetailViewController") as! BuildingDetailViewController

        buildingDetailViewController.building = building
        self.navigationController?.pushViewController(buildingDetailViewController, animated: true)
    }

    func refreshMap() {
        refreshMapAnnotations()
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            if !userLocationSet {
                centerMapOnLocation(location: location)
                userLocationSet = true
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error :: (error)")
    }
}


extension MapViewController : LocationSearchDelegate {
    func buildingSelected(building: Building) {
        resultsSearchController?.searchBar.text = building.name
        centerMapOnLocation(location: CLLocation(latitude: building.location.latitude, longitude: building.location.longitude))
        selectAnnotation(buiding: building)
    }

    func selectAnnotation(buiding: Building)  {
        let annotations = allAnnotations
        let annotation = annotations.filter({ (annotation: MKAnnotation) -> Bool in
            let buildingAnnotation = annotation as! BuildingPinAnnotation
            return buildingAnnotation.building?.id == buiding.id
        }).first

        mapView.selectAnnotation(annotation!, animated: true)
    }
}

