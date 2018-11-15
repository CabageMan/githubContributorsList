//
//  ContributorsList.swift
//  githubContributorsList
//
//  Created by ViktorsMacbook on 12.11.18.
//  Copyright © 2018 ViktorsMacbook. All rights reserved.
//

import UIKit
import Foundation

struct Contributor: Codable {
    var login: String = ""
    var id: Int = 0
    var avatarUrl: String = ""
}

// Initialization of the contributors data array
var contributors = [Contributor]()

// Initialize the activity indicator
var activityIndicator = UIActivityIndicatorView()

class ContributorsList: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set refreshControl
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.backgroundColor = UIColor.gray
        self.refreshControl?.tintColor = UIColor.white
        self.refreshControl?.addTarget(self, action: #selector(refreshData(_:)),
                                                for: UIControlEvents.valueChanged)
        
        // Set the activity indicator
        activityIndicator.color = UIColor.gray
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        self.tableView.backgroundView = activityIndicator
        
        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Tableview data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contributors.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Set cell reusable identifier
        let cellIdentifier = "contributorCell"
        
        // Create an instance of table view cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ContributorCell else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        // Get the contributor's data
        let contributor = contributors[indexPath.row]
        
        // Fil the contributors data
        cell.avatarImage.image = UIImage(named: "placeHolderImage.jpg")
        cell.loginLabel.text = "Login: " + contributor.login
        cell.idLabel.text = "ID: " + String(contributor.id)
        
        // Configure the request and replace the avatar image if it exists
        let dataUrl = URL(string: contributor.avatarUrl)!
        let session = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        
        dataTask = session.dataTask(with: dataUrl) { data, response, error in
            if let error = error {
                print("DataTask error: " + error.localizedDescription)
            } else if let imageData = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                let image = UIImage(data: imageData)
                
                if image != nil {
                    DispatchQueue.main.async {
                        // Get table view cell and set image
                        cell.avatarImage.image = image
                    }
                }
                
                
            }
        }
        dataTask?.resume()
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Check the segue identifier
        if segue.identifier == "showContributorDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                // Get selected contributor data
                let contributor = contributors[indexPath.row]
                let cell: ContributorCell = self.tableView.cellForRow(at: indexPath) as! ContributorCell
                
                // Get instance of contributor details controller
                let destinationController = segue.destination as! ContributorDetails
                
                // Set contributor details
                destinationController.contributorLogin = contributor.login
                destinationController.contributorAvatar = cell.avatarImage.image!
                
            }
        }
    }
    
    @objc private func refreshData(_ sender: Any) {
        // Fetch Weather Data
        getData()
    }
    
    func getData() {
        
        // Start activity indicator
        if activityIndicator.isHidden {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        }
        
        // Stop refresh control animation
        if (self.refreshControl != nil) {
            self.refreshControl?.endRefreshing()
        }
        
        // Create URL of our request
        let dataUrl = URL(string: "https://api.github.com/repos/videolan/vlc/contributors")!
        
        // Initialize session with default configuration
        let session = URLSession(configuration: .default)
        
        // Create URLSessionDataTask variable
        var dataTask: URLSessionDataTask?
        
        // Make request for contributors data
        
        dataTask = session.dataTask(with: dataUrl) { data, response, error in
            if let error = error {
                // Stop activity indeicator
                if !activityIndicator.isHidden {
                    activityIndicator.isHidden = true
                    activityIndicator.stopAnimating()
                }
                print("DataTask error: " + error.localizedDescription)
            } else if let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    DispatchQueue.main.async {
                        for person in json as! [Dictionary<String, AnyObject>] {
                            
                            let contributor = Contributor(login: person["login"] as! String,
                                                             id: person["id"] as! Int,
                                                      avatarUrl: person["avatar_url"] as! String)
                            
                            contributors.append(contributor)
                            
                        }
                        
                        // Stop activity indeicator
                        if !activityIndicator.isHidden {
                            activityIndicator.isHidden = true
                            activityIndicator.stopAnimating()
                        }
                        
                        // Reload table view with fresh data
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    // Stop activity indeicator
                    if !activityIndicator.isHidden {
                        activityIndicator.isHidden = true
                        activityIndicator.stopAnimating()
                    }
                    print("DataTask error: " + error.localizedDescription)
                }
                
                
                
            }
        }
        dataTask?.resume()
    }

}
