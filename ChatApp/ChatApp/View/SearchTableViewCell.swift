//
//  SearchTableViewCell.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 11/11/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var fullName: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func setupCell(name: String) {
        fullName.text = name
    }

    

}
