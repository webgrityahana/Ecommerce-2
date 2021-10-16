//
//  CartViewController.swift
//  GarnierShop
//
//  Created by Anand Baid on 8/24/21.
//

import UIKit

class CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var arrdata = [jsonstruct]()
    var categorydata = [Categories]()
    var imgdata = [Images]()
    
    var cartArray = [CartStruct]()
    
    @IBOutlet var cartTableView: UITableView!
    
    @IBOutlet var totalCount: UILabel!
    @IBOutlet var subtotalPrice: UILabel!
    @IBOutlet var shippingPrice: UILabel!
    @IBOutlet var totalPrice: UILabel!
    @IBOutlet var proceedBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCartData()
        
        displaySubTotal()

        proceedBtn.layer.cornerRadius = 30
        proceedBtn.clipsToBounds = true
        
        let count = cartArray.count
        totalCount.text = "(\(count) item(s))"
        
        //displayTotal()
    }
    
    /*func displayTotal() {
        let pricing1 = Double(total_price)
        let pricing2 = Double(shippingPrice.text!)
        let pricing = Double(pricing1 + pricing2!)
        totalPrice.text = "$\(pricing)"
    }*/
    
    func getCartData() {
           let defaults = UserDefaults.standard
           if let data = defaults.data(forKey: "cartt") {
               cartArray = try! PropertyListDecoder().decode([CartStruct].self, from: data)
               totalCount.text = "(\(cartArray.count) item(s))"
               cartTableView.reloadData()
           }
       }
    
    @IBAction func proceedBtnTapped(_ sender: Any) {
        showActionsheet()
    }
    
    /*@IBAction func sub1btnTapped(_ sender: Any) {
        if counter1 > 0 { counter1 -= 1 }
        callback?(counter1)
    }
    
    @IBAction func add1btnTapped(_ sender: Any) {
        counter1 += 1
        callback?(counter1)
    }*/
    
    
    func showActionsheet() {
        let color1 = hexStringToUIColor(hex: "#000000")
        
        //self.window!.tintColor = UIColor.blue
        //actionsheet.view.tintColor = UIColor.red
        
        let titleFont = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
        let titleAttrString = NSMutableAttributedString(string: "Select Payment Method", attributes: titleFont)
        let actionsheet = UIAlertController(title: nil, message: nil,  preferredStyle: .actionSheet)
        actionsheet.setValue(titleAttrString, forKey:"attributedTitle")
        
        //let actionsheet = UIAlertController(title: "Select Payment Method", message: nil, preferredStyle: .actionSheet)

        actionsheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let action1 = UIAlertAction(title: "Paypal", style: .default, handler: { action1 in print("tapped Dismiss")
        })
        let image1 = UIImage(named: "Image 18.png")
        action1.setValue(image1?.withRenderingMode(.alwaysOriginal), forKey: "image")
        actionsheet.addAction(action1)
        
        action1.setValue(color1, forKey: "titleTextColor")
        
        let action2 = UIAlertAction(title: "Credit or Debit Card", style: .default, handler: { action2 in //print("tapped Dismiss")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let paymentVC = storyboard.instantiateViewController(withIdentifier: "PaymentViewController2") as! PaymentViewController2
            paymentVC.receivedString = self.totalPrice.text!
            self.navigationController?.pushViewController(paymentVC, animated: true)
        })
        let image2 = UIImage(named: "Image 20.png")
        action2.setValue(image2?.withRenderingMode(.alwaysOriginal), forKey: "image")
        actionsheet.addAction(action2)
        
        action2.setValue(color1, forKey: "titleTextColor")
        
        let action3 = UIAlertAction(title: "Apple Pay", style: .default, handler: { action3 in print("tapped Dismiss")
        })
        let image3 = UIImage(named: "Image 19.png")
        action3.setValue(image3?.withRenderingMode(.alwaysOriginal), forKey: "image")
        actionsheet.addAction(action3)
        
        action3.setValue(color1, forKey: "titleTextColor")
     
        actionsheet.view.backgroundColor = .white
        
        actionsheet.view.layer.cornerRadius = 15
        actionsheet.view.clipsToBounds = true
        
        present(actionsheet, animated: true, completion: nil)
    }
    
    //Color Func
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCellTableViewCell", for: indexPath) as! CartCellTableViewCell
 
        cell.cartImageView.downloadImage(from: cartArray[indexPath.row].cartItems.images.first?.src ?? "place_holder_image")

        cell.productNameCart.text = cartArray[indexPath.row].cartItems.name
        cell.prodductDescCart.text = cartArray[indexPath.row].cartItems.categories.first?.type
        cell.productPriceCart.text = "$\(cartArray[indexPath.row].cartItems.price)"
        
        cell.addBtn.addTarget(self, action: #selector(add(sender:)), for: .touchUpInside)
        cell.addBtn.tag = indexPath.row
        
        let cartQuantity = cartArray[indexPath.row].cartQuantity
        cell.prodCount.text = "\(cartQuantity)"
        
        if cartQuantity >= 0 {
            cell.subBtn.isUserInteractionEnabled = true;
            cell.subBtn.addTarget(self, action: #selector(sub(sender:)), for: .touchUpInside)
            cell.subBtn.tag = indexPath.row
        } else {
            cell.subBtn.isUserInteractionEnabled = false;
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cartArray = DetailViewController().updateCartItems(name: cartArray[indexPath.row].cartItems.name)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            self.displaySubTotal()
            //self.displayTotal()
        }
    }
    
    @objc func add(sender: UIButton){
        if cartArray[sender.tag].cartQuantity >= 0 {
            cartArray[sender.tag].cartQuantity += 1
            self.updateCartItems(data: cartArray[sender.tag], index: sender.tag)
            //cartTableView.reloadData()
            self.getCartData()
            self.displaySubTotal()
            //self.displayTotal()
        }
    }
    
    @objc func sub(sender: UIButton){
        if cartArray[sender.tag].cartQuantity > 0 {
            cartArray[sender.tag].cartQuantity -= 1
            self.updateCartItems(data: cartArray[sender.tag], index: sender.tag)
            cartTableView.reloadData()
            self.displaySubTotal()
            //self.displayTotal()
        }
    }
    
    func updateCartItems(data: CartStruct, index: Int) {
        let defaults = UserDefaults.standard
        if let cdata = defaults.data(forKey: "cartt") {
            var cartArray = try! PropertyListDecoder().decode([CartStruct].self, from: cdata)
            cartArray[index] = data
            if let updatedCart = try? PropertyListEncoder().encode(cartArray) {
                UserDefaults.standard.set(updatedCart, forKey: "cartt")
            }
        } else {
            if let updatedCart = try? PropertyListEncoder().encode([data]) {
                UserDefaults.standard.set(updatedCart, forKey: "cartt")
            }
        }
    }
    
    //var total_price: Float = 0.0
    
    func displaySubTotal() {
        
        var total_price: Float = 0.0
          for items in cartArray {
              if let price = Float(items.cartItems.price) {
                  total_price += Float(items.cartQuantity) * price
              }
          }
          subtotalPrice.text = "$\(total_price)"
        
        let pricing1 = Double(total_price)
        //let pricing2 = Double(shippingPrice.text!)
        let pricing = Double(pricing1 + 4.99)
        
        totalPrice.text = "$\(pricing)"
        //shippingPrice.text = "$\(4.99)"
        
        /*if cartArray.count == 1 {
            let p1 = Double(cartArray[0].cartItems.price)
            let p2 = Double(cartArray[0].cartQuantity)
            let p = Double(p1! * p2)
            
            let x1 = Double(p)
            subtotalPrice.text = "\(x1)"
        }

        if cartArray.count == 2 {
            
            let p1 = Double(cartArray[0].cartItems.price)
            let p2 = Double(cartArray[0].cartQuantity)
            let p = Double(p1! * p2)
            
            let q1 = Double(cartArray[1].cartItems.price)
            let q2 = Double(cartArray[1].cartQuantity)
            let q = Double(q1! * q2)
            
            let x2 = Double(p + q)
            subtotalPrice.text = "\(x2)"
        }
        
        if cartArray.count == 3 {
            
            let p1 = Double(cartArray[0].cartItems.price)
            let p2 = Double(cartArray[0].cartQuantity)
            let p = Double(p1! * p2)
            
            let q1 = Double(cartArray[1].cartItems.price)
            let q2 = Double(cartArray[1].cartQuantity)
            let q = Double(q1! * q2)
        
            let r1 = Double(cartArray[2].cartItems.price)
            let r2 = Double(cartArray[2].cartQuantity)
            let r = Double(r1! * r2)
            
            let x3 = Double(p + q + r)
            subtotalPrice.text = "\(x3)"
        }
        
        if cartArray.count == 4 {
            
            let p1 = Double(cartArray[0].cartItems.price)
            let p2 = Double(cartArray[0].cartQuantity)
            let p = Double(p1! * p2)
            
            let q1 = Double(cartArray[1].cartItems.price)
            let q2 = Double(cartArray[1].cartQuantity)
            let q = Double(q1! * q2)
        
            let r1 = Double(cartArray[2].cartItems.price)
            let r2 = Double(cartArray[2].cartQuantity)
            let r = Double(r1! * r2)
            
            let s1 = Double(cartArray[3].cartItems.price)!
            let s2 = Double(cartArray[3].cartQuantity)
            let s = Double(s1 * s2)
            
            let x4 = Double(p + q + r + s)
            subtotalPrice.text = "\(x4)"
        }
        
        if cartArray.count == 5 {
            
            let p1 = Double(cartArray[0].cartItems.price)
            let p2 = Double(cartArray[0].cartQuantity)
            let p = Double(p1! * p2)
            
            let q1 = Double(cartArray[1].cartItems.price)
            let q2 = Double(cartArray[1].cartQuantity)
            let q = Double(q1! * q2)
        
            let r1 = Double(cartArray[2].cartItems.price)
            let r2 = Double(cartArray[2].cartQuantity)
            let r = Double(r1! * r2)
            
            let s1 = Double(cartArray[3].cartItems.price)!
            let s2 = Double(cartArray[3].cartQuantity)
            let s = Double(s1 * s2)
            
            let t1 = Double(cartArray[4].cartItems.price)!
            let t2 = Double(cartArray[4].cartQuantity)
            let t = Double(t1 * t2)
            
            let x5 = Double(p + q + r + s + t)
            subtotalPrice.text = "\(x5)"
        }*/
    }
}













