//
//  ContributorsList.swift
//  githubContributorsList
//
//  Created by ViktorsMacbook on 12.11.18.
//  Copyright © 2018 ViktorsMacbook. All rights reserved.
//

import UIKit

// Initialization the contributors data array
var contributors = [Dictionary<String, AnyObject>]()

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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        // Configure the cell...

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
                    //let json = try JSONSerialization.jsonObject(with: data, options:[]) as! [String: Any]
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    DispatchQueue.main.async {
                        for person in json as! [Dictionary<String, AnyObject>] {
                            var personData = [String: AnyObject]()
                            
                            personData.updateValue(person["login"]!, forKey: "login")
                            personData.updateValue(person["id"]!, forKey: "id")
                            personData.updateValue(person["avatar_url"]!, forKey: "avatar_url")
                            
                            contributors.append(personData)
                        }
                        print(contributors)
                    }
                    
                } catch {
                    print("DataTask error: " + error.localizedDescription)
                }
                
                
                
            }
        }
        dataTask?.resume()
    }

}
