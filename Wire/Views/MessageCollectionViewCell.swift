//
//  MessageCollectionViewCell.swift
//  Wire
//
//  Created by Will Tyler on 1/2/19.
//  Copyright © 2019 Will Tyler. All rights reserved.
//

import UIKit


final class MessageCollectionViewCell: UICollectionViewCell {

	static let cellID = "MessageCollectionViewCell"

	override func layoutSubviews() {
		super.layoutSubviews()

		backgroundColor = Colors.cell
	}

}
