//
//  FundCell.swift
//  WildCharity
//
//  Created by Egor on 27/09/2019.
//  Copyright © 2019 EgorHristoforov. All rights reserved.
//

import UIKit
import Kingfisher

class FundCell: UITableViewCell {

    @IBOutlet weak var fundName: UILabel!
    @IBOutlet weak var fundLogoImage: UIImageView!
    @IBOutlet weak var fundBgImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func setupCell(fund: Fund) {
        fundName.text = fund.name
        fetchImage(url_img: fund.background_url, for: fundBgImage)
        fetchImage(url_img: fund.logo_url, for: fundLogoImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func fetchImage(url_img: String, for view: UIImageView) {
        if let url = URL(string: url_img){
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    view.kf.setImage(with: url)
                }
            }
        }
    }

}
