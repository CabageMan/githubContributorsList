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
    
    // Override the property name to match the respective JSON field name
    
    enum CodingKeys : String, CodingKey {
        case login = "first_Name"
        case id
        case avatarUrl = "medium_URL"
    }
    
}

// Initialization the contributors data array
var contributors = [Contributor]()

class ContributorsList: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
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
        cell.loginLabel.text = contributor.login
        cell.idLabel.text = String(contributor.id)
        
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
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func getData() {
        
        // Create URL of our request
        let dataUrl = URL(string: "https://api.github.com/repos/videolan/vlc/contributors")!
        
        // Initialize session with default configuration
        let session = URLSession(configuration: .default)
        
        // Create URLSessionDataTask variable
        var dataTask: URLSessionDataTask?
        
        // Make request for contributors data
        
        dataTask = session.dataTask(with: dataUrl) { data, response, error in
            if let error = error {
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
                        
                        self.tableView.reloadData()
                    }
                    
                } catch {
                    print("DataTask error: " + error.localizedDescription)
                }
                
                
                
            }
        }
        dataTask?.resume()
    }

}
