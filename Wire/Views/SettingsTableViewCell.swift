//
//  SettingsTableViewCell.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class SettingsTableViewCell: UITableViewCell {

	static let cellID = "SettingsTableViewCell"

	override func layoutSubviews() {
		super.layoutSubviews()

		backgroundColor = Colors.cell
	}

}
