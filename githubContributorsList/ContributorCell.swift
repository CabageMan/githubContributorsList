//
//  ContributorCell.swift
//  githubContributorsList
//
//  Created by ViktorsMacbook on 12.11.18.
//  Copyright © 2018 ViktorsMacbook. All rights reserved.
//

import UIKit

class ContributorCell: UITableViewCell {
    
    //MARK: Properties
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
