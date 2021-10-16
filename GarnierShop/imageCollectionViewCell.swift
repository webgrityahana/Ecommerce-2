//
//  imageCollectionViewCell.swift
//  GarnierShop
//
//  Created by Anand Baid on 9/24/21.
//

import UIKit

class imageCollectionViewCell: UICollectionViewCell {
    
    var imgdata = [Images]()
    var categorydata = [Categories]()
    var arrdata = [jsonstruct]()

    var detailInfo: jsonstruct?
    var cartArray = [CartStruct]()
    
    @IBOutlet var contentCellFrame: UIView!
    @IBOutlet var cellimg: UIImageView!
    
    func updateCellHighlightColor() {
        contentCellFrame.backgroundColor = (isSelected ? .systemGray5 : .white)
        //backgroundColor = (isSelected ? .red : .white)
    }
}
