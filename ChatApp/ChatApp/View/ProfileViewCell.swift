//
//  ProfileViewCell.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 11/5/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

class ProfileViewCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setupCell(title: String, detail: String) {
        titleLabel.text = title
        detailLabel.text = detail
    }
}
