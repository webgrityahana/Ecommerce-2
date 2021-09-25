//
//  imageTableViewCell.swift
//  GarnierShop
//
//  Created by Anand Baid on 9/24/21.
//

import UIKit

class imageTableViewCell: UITableViewCell {
    
    var imgdata = [Images]()
    var categorydata = [Categories]()
    var arrdata = [jsonstruct]()

    var detailInfo: jsonstruct?
    var cartArray = [CartStruct]()

    @IBOutlet var imageCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}



/*extension UIImageView {
    func downloadImage(from url: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) { (data,response,error) in
            if error != nil {
                print("error")
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}*/
