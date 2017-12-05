//
//  SearchResults.swift
//  FindIt xcode 8.3
//
//  Created by Rytis on 30/11/2017.
//  Copyright © 2017 Rytis. All rights reserved.
//

import UIKit

class SearchResults: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    let tableView = UITableView()
    var cellContent = [String]()
    
    let cellId = "cellid"
    let allUsers = EveryUser()
    var postId = [String]()
    var messagesInPost = [String]()
    var allUids = [String]()
    var cities = [String]()
    var locations = [String]()
    var date = [Double]()
    var emails = [String]()
    var downloadUrls = [String]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AllItemsTableViewCell.self, forCellReuseIdentifier: cellId)
        view.addSubview(tableView)
        tableView.frame = view.frame
        view.backgroundColor = .white
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
   

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AllItemsTableViewCell
        cell.awakeFromNib()
        cell.infoLabel.text = cellContent[indexPath.row]
        cell.cityLabel.text = cities[indexPath.row]
        let profileImageURL = downloadUrls[indexPath.row]
        cell.womanImage.loadImageUsingCacheWithUrlString(profileImageURL)
        cell.locationLabel.text = locations[indexPath.item]
        let date = Date(timeIntervalSince1970:self.date[indexPath.item])
        cell.nameLabel.text = emails[indexPath.row]
        cell.dateLabel.text = makeDate(date: date)
        cell.selectionStyle = UITableViewCellSelectionStyle.none

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height - 40
    }
    
    func makeDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        // dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        
        return strDate
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellContent.count
    }
    
}

