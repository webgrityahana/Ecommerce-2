//
//  ViewController.swift
//  GarnierShop
//
//  Created by Anand Baid on 8/11/21.
//

import UIKit
import Alamofire
import OAuthSwift
import SwiftyJSON

struct jsonstruct: Codable {
    let name: String
    let catalog_visibility: String
    let short_description: String
    let description: String
    let price: String
    let categories: [Categories]
    let images: [Images]
    
    enum CodingKeys: String, CodingKey {
        case name
        case catalog_visibility
        case short_description
        case description
        case price
        case categories
        case images
    }
}

struct Categories: Codable {
    let type: String
    
    enum  CodingKeys: String, CodingKey {
        case type = "name"
    }
}

struct Images: Codable {
    let src: String
}

class ViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var cartview: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var searchbar: UISearchBar!
    @IBOutlet var itemCount: UILabel!
    @IBOutlet var cellView: UIView!
    @IBOutlet var headingLbl: UILabel!
    
     
    var imgdata = [Images]()
    var categorydata = [Categories]()
    var arrdata = [jsonstruct]()
    
    var detailInfo: jsonstruct?
    var cartArray = [CartStruct]()
    
    var filterData = [jsonstruct]()
    
    var searching = false
        
    override func viewDidLoad() {
        super.viewDidLoad()

        filterData = arrdata
        
        //let color = UIColor.init(named: "#2455F4")
        //color.hexDescription(true)
        
        let value = UserDefaults.standard.string(forKey: "CountAddedProducts")
        
        if value != nil {
            itemCount.text = value
        }
        else {
            itemCount.text = "0"
        }
        
        searchbar.frame = searchbar.frame.inset(by: UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0))
        
        /*if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                       let atrString = NSAttributedString(string: "Search",
                                                          attributes: [.foregroundColor : color,
                                                                       .font : UIFont.systemFont(ofSize: 10, weight: .bold)])
                       textfield.attributedPlaceholder = atrString

                   }*/

        
        if let textField = searchbar.value(forKey: "searchField") as? UITextField {
            textField.backgroundColor = .white
            //textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkText])
            
            let atrString = NSAttributedString(string: "Search",
                                               attributes: [.font : UIFont.systemFont(ofSize: 20, weight: .regular)])
            textField.attributedPlaceholder = atrString
            
            let color2 = hexStringToUIColor(hex: "#2455F4")
            textField.textColor = color2
            
            let backgroundView = textField.subviews.first
            if #available(iOS 11.0, *) { // If `searchController` is in `navigationItem`
                backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(0.3) //Or any transparent color that matches with the `navigationBar color`
                backgroundView?.subviews.forEach({ $0.removeFromSuperview() }) // Fixes an UI bug when searchBar appears or hides when scrolling
            }
            backgroundView?.layer.cornerRadius = 15
            backgroundView?.layer.masksToBounds = true
        }
        
        searchbar.backgroundColor = .white
        searchbar.layer.cornerRadius = 15
        searchbar.clipsToBounds = true
        
        /*if let textfield = searchbar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.init(named: "2455F4")
        }*/
        
        cartview.layer.cornerRadius = cartview.frame.width / 2
        cartview.layer.cornerRadius = cartview.frame.height / 2
        cartview.layer.masksToBounds = true
        
        //tableView.layer.cornerRadius = 15
        //tableView.clipsToBounds = true

        getdata()
        tableView.reloadData()
        setUpSearchBar()
        
        hideKeyboard()
        
        let color1 = hexStringToUIColor(hex: "#2C2C2E")
        headingLbl.textColor = color1
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
    
    func lblStoringCount(data: CartStruct) {
        let defaults = UserDefaults.standard
        if let cdata = defaults.data(forKey: "cartt") {
            var cartArray = try! PropertyListDecoder().decode([CartStruct].self, from: cdata)
            cartArray.append(data)
            itemCount.text = "\(cartArray.count)"
            if (try? PropertyListEncoder().encode(cartArray)) != nil {
                //UserDefaults.standard.set(updatedCart, forKey: "cartt")
            }
            UserDefaults.standard.set(itemCount.text, forKey: "CountAddedProducts")
        } else {
            if (try? PropertyListEncoder().encode([data])) != nil {
                //UserDefaults.standard.set(updatedCart, forKey: "cartt")
            }
        }
    }
    
    @IBAction func cartBtnTapped(_ sender: Any) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController
        //detail?.cartArray = cartArray
        self.navigationController?.pushViewController(detail!, animated: true)
    }
    
    func getdata() {
        
        let url = URL(string: "https://webgrity.in/IOS-Testing/wp-json/wc/v3/products?consumer_key=ck_542029bdf259fa5f5a26a27242d8fa8324f13d18&consumer_secret=cs_a4196e9ef5d0c5a8fa7015cdca7b95b4942c5c99")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{if error == nil{
                self.arrdata = try JSONDecoder().decode([jsonstruct].self, from: data!)

                    print(self.arrdata)
                    DispatchQueue.main.async {
                         self.tableView.reloadData()
                    }
                }
            
            }catch{
                print("Error in get json data")
            }
            
        }.resume()
        tableView.reloadData()
    }
    
    private func setUpSearchBar() {
        searchbar.delegate = self
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return filterData.count
        }
        else {
            return arrdata.count
        }
     }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CellTableViewCell
        
        //cell.lblname?.text = "Name : \(arrdata[indexPath.row].name)"
        //cell?.lblname.text = "Name: " + arrdata[indexPath.row].name
        if searching {
            cell?.img.downloadImage(from: (self.filterData[indexPath.item].images.first?.src)!)

            cell?.lblName.text = filterData[indexPath.row].name
            cell?.lblSHDesc.text = filterData[indexPath.row].categories.first?.type
            cell?.lblDesc.text = filterData[indexPath.row].short_description
            cell?.lblPrice.text = "$\(filterData[indexPath.row].price)"
        }
        else {
            cell?.img.downloadImage(from: (self.arrdata[indexPath.item].images.first?.src)!)

            cell?.lblName.text = arrdata[indexPath.row].name
            cell?.lblSHDesc.text = arrdata[indexPath.row].categories.first?.type
            cell?.lblDesc.text = arrdata[indexPath.row].short_description
            cell?.lblPrice.text = "$\(arrdata[indexPath.row].price)"
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        detail?.detailInfo = arrdata[indexPath.row]
        self.navigationController?.pushViewController(detail!, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filterData = arrdata
            tableView.reloadData()
            return
        }
        filterData = arrdata.filter({ animal -> Bool in
            (animal.categories.first?.type.lowercased().contains(searchText.lowercased()))!
        })

        searching = true
        tableView.reloadData()
    }
}

extension UIViewController {
    func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImageView {
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
}



