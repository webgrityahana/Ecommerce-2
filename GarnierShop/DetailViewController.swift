//
//  DetailViewController.swift
//  GarnierShop
//
//  Created by Anand Baid on 8/21/21.
//

import UIKit

struct CartStruct : Codable {
    var cartItems: jsonstruct
    var cartQuantity: Int
}

class DetailViewController: UIViewController {
    
    var arrdata = [jsonstruct]()
    var categorydata = [Categories]()
    var imgdata = [Images]()
    
    var detailInfo: jsonstruct?
    var cartArray = [CartStruct]()

    @IBOutlet weak var prodName: UILabel!
    @IBOutlet weak var probName2: UILabel!
    @IBOutlet weak var prodSHDesc: UILabel!
    @IBOutlet weak var prodDesc: UILabel!
    @IBOutlet weak var prodPrice: UILabel!
    @IBOutlet weak var probImage: UIImageView!
    @IBOutlet var container: UIView!
    @IBOutlet var ratingView: UIView!
    @IBOutlet var addToCartbtn: UIView!
    @IBOutlet var addingTOCart: UIButton!
    //@IBOutlet var one: UIView!
    //@IBOutlet var two: UIView!
    //@IBOutlet var three: UIView!
    //@IBOutlet var imgone: UIImageView!
    //@IBOutlet var imgtwo: UIImageView!
    //@IBOutlet var imgthree: UIImageView!
    @IBOutlet var cart4View: UIView!
    @IBOutlet var cartCount: UILabel!
    
    @IBOutlet var imageCollectionView: UICollectionView!
    
    
    var Image = UIImage()
    var Name = ""
    var Name2 = ""
    var SH_desc = ""
    var Desc = ""
    var Price = ""
    var Img1 = UIImage()
    var Img2 = UIImage()
    var Img3 = UIImage()
    
    /*var callback : ((Int)->())?
    var counter1 = 0 {
        didSet {
            cartCount.text = "\(counter1)"
        }
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UserDefaults.standard.string(forKey: "CountAddedProducts")
        
        if value == nil {
            cartCount.text = "0"
        }
        else {
            cartCount.text = value
        }

        probImage.layer.cornerRadius = 15
        probImage.clipsToBounds = true
        
        container.layer.cornerRadius = 50
        container.clipsToBounds = true
        
        ratingView.layer.cornerRadius = 20
        ratingView.clipsToBounds = true
        ratingView.layer.borderWidth = 1
        ratingView.layer.borderColor = UIColor.lightGray.cgColor
        
        addToCartbtn.layer.cornerRadius = 20
        addToCartbtn.clipsToBounds = true
        
        /*one.layer.cornerRadius = 15
        one.clipsToBounds = true
        one.layer.borderWidth = 1
        one.layer.borderColor = UIColor.lightGray.cgColor
        
        two.layer.cornerRadius = 15
        two.clipsToBounds = true
        two.layer.borderWidth = 1
        two.layer.borderColor = UIColor.lightGray.cgColor
        
        three.layer.cornerRadius = 15
        three.clipsToBounds = true
        three.layer.borderWidth = 1
        three.layer.borderColor = UIColor.lightGray.cgColor*/
        
        cart4View.layer.cornerRadius = cart4View.frame.width / 2
        cart4View.layer.cornerRadius = cart4View.frame.height / 2
        cart4View.layer.masksToBounds = true
        
        self.updateUI()
        
        getdata()
    }

    override func viewWillAppear(_ animated: Bool) {
               if let info = detailInfo {
                   let buttonTItle = (self.checkCartData(cartInfo: info) ? "Go to Cart"  : "Add to Cart")
                   addingTOCart.setTitle(buttonTItle, for: .normal)
               }
           }
    
    func updateUI(){
        if let detailInfo = detailInfo {
            if let urlString = detailInfo.images.first?.src {
                self.probImage.downloadImage(from: urlString)
            }
            
            prodName.text = detailInfo.name
            probName2.text = detailInfo.name
            prodSHDesc.text = detailInfo.categories.first!.type
            prodDesc.text = detailInfo.description
            prodPrice.text = "$\(detailInfo.price)"
            
            /*let imagesArray = detailInfo.images
                        
            if imagesArray.count > 0{
                self.probImage.downloadImage(from: detailInfo.images[0].src)
                self.imgone.downloadImage(from: detailInfo.images[0].src)
            }
            
            if imagesArray.count > 1 {
                self.imgtwo.downloadImage(from: detailInfo.images[1].src)
            }
            
            if imagesArray.count > 2 {
                self.imgthree.downloadImage(from: detailInfo.images[2].src)
            }*/
        }
    }
    
    @IBAction func imgBtnTapped(_ sender: UIButton) {
        let imgarray = detailInfo?.images
        
        for item in [imgarray] {
            
            if item?.count == 1 {
                if ((detailInfo?.images[0].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[0].src)!)
                }
            }
            
            if item?.count == 2 {
                if ((detailInfo?.images[0].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[0].src)!)
                }
                if ((detailInfo?.images[1].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[1].src)!)
                }
            }
            
            if item?.count == 3 {
                if ((detailInfo?.images[0].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[0].src)!)
                }
                if ((detailInfo?.images[1].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[1].src)!)
                }
                if ((detailInfo?.images[2].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[2].src)!)
                }
            }
            
            if item?.count == 4 {
                if ((detailInfo?.images[0].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[0].src)!)
                }
                if ((detailInfo?.images[1].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[1].src)!)
                }
                if ((detailInfo?.images[2].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[2].src)!)
                }
                if ((detailInfo?.images[3].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[3].src)!)
                }
            }
            
            if item?.count == 5 {
                if ((detailInfo?.images[0].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[0].src)!)
                }
                if ((detailInfo?.images[1].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[1].src)!)
                }
                if ((detailInfo?.images[2].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[2].src)!)
                }
                if ((detailInfo?.images[3].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[3].src)!)
                }
                if ((detailInfo?.images[4].src) != nil) {
                    probImage.downloadImage(from: (detailInfo?.images[4].src)!)
                }
            }
        }
    }
    
    
    /*@IBAction func firstImgBtnTapped(_ sender: Any) {
        if let imageURL = detailInfo?.images[0].src {
            probImage.downloadImage(from: imageURL)
            
            one.layer.borderWidth = 1
            one.layer.borderColor = UIColor.orange.cgColor
            one.backgroundColor = .systemGray5
            
            two.layer.borderWidth = 1
            two.layer.borderColor = UIColor.lightGray.cgColor
            two.backgroundColor = .clear
            
            three.layer.borderWidth = 1
            three.layer.borderColor = UIColor.lightGray.cgColor
            three.backgroundColor = .clear
        }
    }
    
    @IBAction func secondImgBtnTapped(_ sender: Any) {
        if let imageURL = detailInfo?.images[1].src {
            probImage.downloadImage(from: imageURL)
            
            one.layer.borderWidth = 1
            one.layer.borderColor = UIColor.lightGray.cgColor
            one.backgroundColor = .clear
            
            two.layer.borderWidth = 1
            two.layer.borderColor = UIColor.orange.cgColor
            two.backgroundColor = .systemGray5
            
            three.layer.borderWidth = 1
            three.layer.borderColor = UIColor.lightGray.cgColor
            three.backgroundColor = .clear
        }
    }
    
    @IBAction func thirdImgBtnTapped(_ sender: Any) {
        if let imageURL = detailInfo?.images[2].src {
            probImage.downloadImage(from: imageURL)
            
            one.layer.borderWidth = 1
            one.layer.borderColor = UIColor.lightGray.cgColor
            one.backgroundColor = .clear
            
            two.layer.borderWidth = 1
            two.layer.borderColor = UIColor.lightGray.cgColor
            two.backgroundColor = .clear
            
            three.layer.borderWidth = 1
            three.layer.borderColor = UIColor.orange.cgColor
            three.backgroundColor = .systemGray5
        }
    }*/
    
    @IBAction func cartTappedToNavigate(_ sender: Any) {
        let cart = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController
        self.navigationController?.pushViewController(cart!, animated: true)
    }
    
    @IBAction func addToCartbtnTapped(_ sender: Any) {
        /*if let info = detailInfo {
            let cartData = CartStruct(cartItems: info, cartQuantity: 1)
            self.saveCart(data: cartData)
            showAlert()
            (sender as AnyObject).setTitle("Go to Cart", for: .normal)
            addToCartbtn.isUserInteractionEnabled = false
            //addToCartbtn.isHidden = true
            //goTOCartbtn.isHidden = false
            //goTOCartbtn.isUserInteractionEnabled = true
        }*/
        /*if !Clicked {
            if let info = detailInfo {
                let cartData = CartStruct(cartItems: info, cartQuantity: 1)
                self.saveCart(data: cartData)
                showAlert()
                addingTOCart.setTitle("Go to Cart", for: .normal)
                UserDefaults.standard.set("Go to Cart", forKey: "btn")
                print("Clicked")
                Clicked = true
                return
            }
        }
        if Clicked {
            print("Perform Action")
            let cart = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController
            self.navigationController?.pushViewController(cart!, animated: true)
        }*/
        if let info = detailInfo {
            if checkCartData(cartInfo: info) {
                let cart = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController
                self.navigationController?.pushViewController(cart!, animated: true)
            } else {
                let cartData = CartStruct(cartItems: info, cartQuantity: 1)
                self.saveCart(data: cartData)
                showAlert()
                (sender as AnyObject).setTitle("Go to Cart", for: .normal)
            }
        }
    }
    
    func checkCartData(cartInfo: jsonstruct) -> Bool {
        guard let cart = self.getCartData() else { return false }
        return (cart.contains(where: { $0.cartItems.name == cartInfo.name }) ? true : false )
    }
    
    func getCartData() -> [CartStruct]? {
        let defaults = UserDefaults.standard
        var tempCart: [CartStruct]?
        if let cdata = defaults.data(forKey: "cartt") {
            tempCart = try! PropertyListDecoder().decode([CartStruct].self, from: cdata)
        }
        return tempCart
    }
    
    func saveCart(data: CartStruct) {
        let defaults = UserDefaults.standard
        if let cdata = defaults.data(forKey: "cartt") {
            var cartArray = try! PropertyListDecoder().decode([CartStruct].self, from: cdata)
            cartArray.append(data)
            cartCount.text = "\(cartArray.count)"
            if let updatedCart = try? PropertyListEncoder().encode(cartArray) {
                UserDefaults.standard.set(updatedCart, forKey: "cartt")
            }
            UserDefaults.standard.set(cartCount.text, forKey: "CountAddedProducts")
        } else {
            if let updatedCart = try? PropertyListEncoder().encode([data]) {
                UserDefaults.standard.set(updatedCart, forKey: "cartt")
            }
        }
    }
    
    func updateCartItems(name: String) -> [CartStruct] {
         guard var cartItems = self.getCartData() else { return [] }
         cartItems = cartItems.filter({ $0.cartItems.name != name })
         if let updatedCart = try? PropertyListEncoder().encode(cartItems) {
             UserDefaults.standard.set(updatedCart, forKey: "cartt")
         }
         UserDefaults.standard.set(cartItems.count, forKey: "CountAddedProducts")
         return cartItems
       }

    func showAlert() {
        let alert = UIAlertController(title: "Item Added to Cart", message: nil, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func getdata() {
        
        let url = URL(string: "https://webgrity.in/IOS-Testing/wp-json/wc/v3/products?consumer_key=ck_542029bdf259fa5f5a26a27242d8fa8324f13d18&consumer_secret=cs_a4196e9ef5d0c5a8fa7015cdca7b95b4942c5c99")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{if error == nil{
                self.arrdata = try JSONDecoder().decode([jsonstruct].self, from: data!)

                    print(self.arrdata)
                    DispatchQueue.main.async {
                         self.imageCollectionView.reloadData()
                    }
                }
            
            }catch{
                print("Error in get json data")
            }
            
        }.resume()
        imageCollectionView.reloadData()
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let imgarray = detailInfo?.images
        return imgarray!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as? imageCollectionViewCell
        
        let imgarray = detailInfo?.images
        cell!.cellimg.downloadImage(from: (imgarray![indexPath.row].src))
        
        cell!.contentCellFrame.layer.cornerRadius = 15
        cell!.contentCellFrame.clipsToBounds = true
        cell!.contentCellFrame.layer.borderWidth = 1
        cell!.contentCellFrame.layer.borderColor = UIColor.lightGray.cgColor
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 93, height: 79)
    }
}
