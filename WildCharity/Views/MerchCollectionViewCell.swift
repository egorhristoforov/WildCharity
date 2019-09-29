//
//  MerchCollectionViewCell.swift
//  WildCharity
//
//  Created by Egor on 29/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit

class MerchCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var merchImage: UIImageView!
    
    public func setupCell(merch: Merch) {
        priceLabel.text = "\(merch.price)"
        merchImage.image = merch.image
    }
}
