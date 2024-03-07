//
//  UserDetailCell.swift
//  SwiftHub
//
//  Created by Sygnoos9 on 10/13/18.
//  Copyright © 2018 Khoren Markosyan. All rights reserved.
//

import UIKit

class UserDetailCell: DefaultTableViewCell {

    override func makeUI() {
        super.makeUI()
        leftImageView.contentMode = .center
        leftImageView.cornerRadius = 0
        leftImageView.snp.updateConstraints { (make) in
            make.size.equalTo(30)
        }
        detailLabel.isHidden = true
        secondDetailLabel.textAlignment = .right
        textsStackView.axis = .horizontal
        textsStackView.distribution = .fillEqually
    }
}
