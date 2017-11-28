//
//  FoundItemsMap.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 05/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class FoundItemsMap: UIViewController, CLLocationManagerDelegate , MKMapViewDelegate, UISearchBarDelegate{
    
    var locationManager = CLLocationManager()
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        //view.addSubview(backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(handleSearch))
        setNeedsStatusBarAppearanceUpdate()
        // BUTINA KAD GALETUM CUSTOMISE
        mapView.delegate = self
        handleMapConstraints()
        getLocations()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(descriptions.count)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    var lon = [String]()
    var lat = [String]()
    var descriptions = [String]()
    var postNames = [String]()
    var downloadURL = [String]()
    var toId = [String]()
    var pinIndex = Int()
    var uids = [String]()
    var isCurrUser = false
    var whichUser = [Bool]()
    var cities = [String]()
    var locations = [String]()
    var dates = [Date]()
    var emails = [String]()
    
    let backButton: UIButton = {
       let back = UIButton()
        back.translatesAutoresizingMaskIntoConstraints = false
        back.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        back.setTitle("Back", for: .normal)
        return back
    }()
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleSearch(){
        
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = myColor
        let cancelButtonAttributes: NSDictionary = [NSForegroundColorAttributeName: UIColor.white]
        UIBarButtonItem.appearance().setTitleTextAttributes(cancelButtonAttributes as? [String : AnyObject], for: UIControlState.normal)
        
        self.searchController.hidesNavigationBarDuringPresentation = false;
        self.definesPresentationContext = false
        present(searchController, animated: true, completion: nil)
        
    }

    
    func handleMapConstraints(){
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
       /* backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 60).isActive = true */
    }
    
    func getLocations(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        uids.removeAll()
        downloadURL.removeAll()
        toId.removeAll()
        postName.removeAll()
        lon.removeAll()
        lat.removeAll()
        cities.removeAll()
        locations.removeAll()
        dates.removeAll()
        emails.removeAll()
        descriptions.append(description)
        let ref = Database.database().reference().child("allPosts").child("found")
        ref.queryOrdered(byChild: "timeStamp").observe( .childAdded, with: { (snapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            
            
            if let latitude = dictionary["lat"] as? String {
                
                let lati = latitude
                let long = dictionary["lon"] as! String
                let description = dictionary["description"] as! String
                let postName = snapshot.key
                let toId = dictionary["uid"] as! String
                let downloadURL = dictionary["downloadURL"] as! String
                let uid = dictionary["uid"] as! String
                let city = dictionary["city"] as! String
                let location = dictionary["locationName"] as! String
                let email = dictionary["email"] as! String
                //let date = dictionary["timeStamp"] as! Double
                let date = Date(timeIntervalSince1970:dictionary["timeStamp"] as! Double)
                
                if uid == Auth.auth().currentUser?.uid {
                    self.isCurrUser = true
                } else {
                    self.isCurrUser = false
                }
                self.emails.append(email)
                self.dates.append(date)
                self.locations.append(location)
                self.cities.append(city)
                self.uids.append(uid)
                self.downloadURL.append(downloadURL)
                self.toId.append(toId)
                self.postNames.append(postName)
                self.lon.append(long)
                self.lat.append(lati)
                self.descriptions.append(description)
                
                DispatchQueue.main.async {
                    self.getAnnotations(lat: lati, lon: long, description: description)
                    ref.removeAllObservers()
                }
            }
        }, withCancel: nil)
        
       
    }
    
    func makeDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }

    
    func getAnnotations(lat: String, lon: String, description: String){
        if lat != ""{
            let location = CLLocationCoordinate2D(latitude: Double(lat)!,longitude: Double(lon)!)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location, span: span)
            //mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.title = description
            annotation.coordinate = location
            
            let newAnnotation = mapView(mapView, viewFor: annotation)
            
            mapView.addAnnotation((newAnnotation!.annotation)!)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        
        let currUser = Auth.auth().currentUser?.uid
        
       
            for user in uids{
                if user == currUser {
                    pinView.pinTintColor = UIColor.red
                    print(user, "current user")
                } else{
                    pinView.pinTintColor = myColor
                    print(user, "<--else user")
                }
            }

        
        
        let rightButton = UIButton(type: .contactAdd)
        rightButton.addTarget(self, action: #selector(toPost), for: .touchUpInside)
        
        
        pinView.animatesDrop = true
        pinView.canShowCallout = true
        pinView.rightCalloutAccessoryView = rightButton
        
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        for item in descriptions{
            if item == (view.annotation!.title!)! {
                pinIndex = descriptions.index(of: item)! - 1
                print("item ",descriptions.index(of: item)!)
            }
        }
        print((view.annotation!.title!)!)
        
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
                //let annotations = self.mapView.annotations
               // self.mapView.removeAnnotations(annotations)
                
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
                    //self.mapView.addAnnotation(annotation)
                    //UserDefaults.standard.set(lat, forKey: "lat")
                    
                   // UserDefaults.standard.set(lon, forKey: "lon")
                    //UserDefaults.standard.set(title, forKey: "title")
                   
                   // UserDefaults.standard.set(city, forKey: "city")
                })
                
            }
        }
    }
    

    
    func toPost(){
        let postInfo = PostInfo()
        
        DispatchQueue.main.async {
            if self.toId[self.pinIndex] != Auth.auth().currentUser?.uid{
                print("pinIndex ",self.pinIndex)
                postName = self.postNames[self.pinIndex]
                posterUid.text = self.emails[self.pinIndex]
                postInfo.toId = self.toId[self.pinIndex]
            //    image.loadImageUsingCacheWithUrlString(self.downloadURL[self.pinIndex])
            //    image.contentMode = .scaleAspectFit
                locationLabel.text = self.locations[self.pinIndex]
                imageUrl = self.downloadURL[self.pinIndex]
                cityLabel.text = self.cities[self.pinIndex]
                dateLabel.text = String(self.makeDate(date:  self.dates[self.pinIndex]))
                descriptiontextField.text = self.descriptions[self.pinIndex + 1]
                self.show(postInfo, sender: self)
            }
        }
    }
    
}
