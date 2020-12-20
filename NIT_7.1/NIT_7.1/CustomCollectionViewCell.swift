//
//  CustomCollectionViewCell.swift
//  NIT_7.1
//
//  Created by Родион Сприкут on 20.12.2020.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func updateCellSize(width: CGFloat, height: CGFloat) {
        widthConstraint.constant = width
        heightConstraint.constant = height
    }
}
