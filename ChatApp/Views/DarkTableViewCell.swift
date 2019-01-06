//
//  DarkTableViewCell.swift
//  Wire
//
//  Created by Will Tyler on 11/10/18.
//  Copyright © 2018 Will Tyler. All rights reserved.
//

import UIKit


class DarkTableViewCell: UITableViewCell {

	static let cellID = "DarkTableViewCell"

	override func layoutSubviews() {
		super.layoutSubviews()

		backgroundColor = Colors.cell
	}

}
