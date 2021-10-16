//
//  SuccessViewController.swift
//  GarnierShop
//
//  Created by Anand Baid on 10/7/21.
//

import UIKit

struct OrderUpdate: Codable {
    let order_key: String
}

class SuccessViewController: UIViewController {
    
    var updatedOrderArray = [OrderUpdate]()
    
    @IBOutlet var lblOrderKey: UILabel!
    
    //var order_id = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getOrderUpdate()
        
        //order_id = updatedOrderArray.first!.order_key
        //lblOrderKey.text = order_id
        
        //lblOrderKey.text = updatedOrderArray.first?.order_key
    }

    
    func getOrderUpdate() {
        let url = URL(string: "https://webgrity.in/IOS-Testing/wp-json/wc/v3/orders?consumer_key=ck_542029bdf259fa5f5a26a27242d8fa8324f13d18&consumer_secret=cs_a4196e9ef5d0c5a8fa7015cdca7b95b4942c5c99")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{if error == nil{
                self.updatedOrderArray = try JSONDecoder().decode([OrderUpdate].self, from: data!)

                    print(self.updatedOrderArray)
                    DispatchQueue.main.async {
                        self.lblOrderKey.text = self.updatedOrderArray[0].order_key
                    }
                
                }
            }catch{
                print("Error in get json data json")
            }
        }.resume()
    }
}
