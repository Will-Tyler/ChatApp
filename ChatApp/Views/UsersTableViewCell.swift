//
//  UsersTableViewCell.swift
//  Wire
//
//  Created by Will Tyler on 11/22/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class UsersTableViewCell: UITableViewCell {

	static let cellID = "UsersTableViewCell"

	override func layoutSubviews() {
		super.layoutSubviews()

		backgroundColor = Colors.cell
		textLabel!.textColor = .white
	}
	
}
