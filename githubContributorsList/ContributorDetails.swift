//
//  ContributorDetails.swift
//  githubContributorsList
//
//  Created by ViktorsMacbook on 12.11.18.
//  Copyright © 2018 ViktorsMacbook. All rights reserved.
//

import UIKit

class ContributorDetails: UIViewController {

    //MARK: Properties
    
    // Initialization the contributors details with default values
    var contributorAvatar: UIImage = UIImage(named: "placeHolderImage.jpg")!
    var contributorLogin: String = "Oops, something went wrong."
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Set up contributor details views
        self.avatarImage.image = contributorAvatar
        self.loginLabel.text = contributorLogin
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

