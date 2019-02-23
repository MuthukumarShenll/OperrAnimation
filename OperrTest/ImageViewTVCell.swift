//
//  ImageViewTVCell.swift
//  OperrTest
//
//  Created by Shenll_IMac on 22/02/19.
//  Copyright © 2019 STS. All rights reserved.
//

import UIKit

class ImageViewTVCell: UITableViewCell {
    
    //MARK: - UIImageView declaration
    @IBOutlet weak var animationImage: UIImageView!
    
    //MARK: - UIView declaration
    @IBOutlet weak var imageContainerView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.imageContainerView.layer.masksToBounds = true
        self.imageContainerView.layer.cornerRadius = 20.0
    }
    
}
