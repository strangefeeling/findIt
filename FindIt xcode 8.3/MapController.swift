//
//  MapController.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 04/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var places = [Dictionary<String, String>()]

class MapController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    
    let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        return searchBar
    }()
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        
       // view.addSubview(searchBar)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
       // view.addSubview(backButton)
        constraints()
        setUpMap()
        setUpLocationManager()
    }

    let searchController = UISearchController(searchResultsController: nil)
    
    func handleSearch(){
        
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = myColor
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)

        self.searchController.hidesNavigationBarDuringPresentation = false;
        self.definesPresentationContext = false
        present(searchController, animated: true, completion: nil)

    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        UIApplication.shared.beginIgnoringInteractionEvents()
        // Activity indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
        
        //hide searchbar
        searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        
        //create the search request
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchBar.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil{
                print("ERROR")
            }
            else {
                //Remove Annotations
                let annotations = self.mapView.annotations
                self.mapView.removeAnnotations(annotations)
                
                //get the data
                let lat = response?.boundingRegion.center.latitude
                let lon = response?.boundingRegion.center.longitude
                
                //Zoom in
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
                let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                let region = MKCoordinateRegion(center: coordinate, span: span)
                self.mapView.setRegion(region, animated: true)
                
                
                let location = CLLocation(latitude: lat!, longitude: lon!)
                
                var city = ""
                var title = ""
                
                CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                    if error != nil {
                        print(error)
                    } else {
                        if let placemark = placemarks?[0]{
                            
                            if placemark.subThoroughfare != nil {
                                title += placemark.subThoroughfare! + " "
                                print("title ", title)
                            }
                            
                            if placemark.thoroughfare != nil {
                                title += placemark.thoroughfare!
                                print("title ", title)
                            }
                            
                            if placemark.locality != nil{
                                city = placemark.locality!
                                print(city, "city")
                            }
                            
                        }
                    }
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: Double(lat!), longitude: Double(lon!))
                    annotation.title = title
                    print("annotation title ",annotation.title)
                    self.mapView.addAnnotation(annotation)
                    UserDefaults.standard.set(lat, forKey: "lat")
                    
                    UserDefaults.standard.set(lon, forKey: "lon")
                    UserDefaults.standard.set(title, forKey: "title")
                    
                    UserDefaults.standard.set(city, forKey: "city")
                })
               
            }
        }
    }

    
    func setUpLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func setUpMap(){
      /*  mapView.mapType = MKMapType.standard
        let location = CLLocationCoordinate2D(latitude: 23.0225,longitude: 72.5714)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "iOSDevCenter-Kirit Modi"
        annotation.subtitle = "Ahmedabad"
        mapView.addAnnotation(annotation)
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapController.longprss(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        mapView.addGestureRecognizer(uilpgr)*/

        print("coordinates ", UserDefaults.standard.string(forKey: "lat"))
        let lat = UserDefaults.standard.string(forKey: "lat")
        let lon = UserDefaults.standard.string(forKey: "lon")
        let title = UserDefaults.standard.string(forKey: "title")
        if lat != nil{
        let location = CLLocationCoordinate2D(latitude: Double(lat!)!,longitude: Double(lon!)!)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = title
        mapView.addAnnotation(annotation)
        let uilpgr = UILongPressGestureRecognizer(target: self, action: #selector(MapController.longprss(gestureRecognizer:)))
        uilpgr.minimumPressDuration = 2
        mapView.addGestureRecognizer(uilpgr)
        }
    }
    
   // @IBOutlet var mapView: MKMapView!
    var manager = CLLocationManager()
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    let backButton: UIButton = {
       let back = UIButton()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.setTitle("Back", for: .normal)
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        return back
    }()
    
   
    
    func longprss(gestureRecognizer: UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.began{
            
            mapView.removeAnnotations(self.mapView.annotations)
            let touchPoint = gestureRecognizer.location(in: self.mapView)
            
            let newCoordinate = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            
            // convertinam newCoordinate, kad galetume irasyt i geocoder
            
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
           
            UserDefaults.standard.set(newCoordinate.latitude, forKey: "lat")
            UserDefaults.standard.set(newCoordinate.longitude, forKey: "lon")
            
            var title = ""
            var city = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
                if error != nil {
                    print(error)
                } else {
                    if let placemark = placemarks?[0]{
                        
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        
                        if placemark.thoroughfare != nil {
                            title += placemark.thoroughfare!
                        }
                        
                        if placemark.locality != nil{
                            city = placemark.locality!
                        }
                        
                    }
                }
            
                if title.isEmpty {
                    title = "Unclear"
                }
                
                if city.isEmpty {
                    title = "Unclear"
                }
            
            UserDefaults.standard.set(title, forKey: "title")
                
            UserDefaults.standard.set(city, forKey: "city")
                
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = newCoordinate
            
            annotation.title = title
            
            self.mapView.addAnnotation(annotation)
            })
        }
    }
    
    func goBack(){
        self.dismiss(animated: true, completion: nil)
    }

    func constraints(){
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
     /*   searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        searchBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true*/
    }

}
