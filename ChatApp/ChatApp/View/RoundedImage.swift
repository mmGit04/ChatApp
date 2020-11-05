//
//  RoundedImage.swift
//  ChatApp
//
//  Created by Mina Milosavljevic on 11/5/20.
//  Copyright © 2020 Mina Milosavljevic. All rights reserved.
//

import UIKit

class RoundedImage: UIImageView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupRoundedImage()
    }
    required init(coder: NSCoder) {
        super.init(coder: coder)!
        setupRoundedImage()
    }
    
    private func setupRoundedImage() {
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}
