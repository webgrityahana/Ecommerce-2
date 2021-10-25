//
//  BillingAddressViewController.swift
//  GarnierShop
//
//  Created by Anand Baid on 10/5/21.
//

import UIKit
import DropDown
import Alamofire

enum APIError:Error {
    case responseProblem
    case decodingProblem
    case encodingProblem
}

// MARK: - JsonstructElement
struct orderStruct: Codable {
    
    let paymentMethod: String
    let paymentMethodTitle: String
    let setPaid: Bool
    let billing: Ing
    let shipping: Ing
    let lineItems: [LineItem]
    let shippingLines: [ShippingLine]
    //let customerNote: String
    
    enum CodingKeys: String, CodingKey {
        
        case paymentMethod = "payment_method"
        case paymentMethodTitle = "payment_method_title"
        case setPaid = "set_paid"
        case billing, shipping
        case lineItems = "line_items"
        case shippingLines = "shipping_lines"
    }
}

// MARK: - Ing
struct Ing: Codable {
    let firstName, lastName, company, address1: String
    let address2, city, state, postcode: String
    let country: String
    let email: String?
    let phone: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case company
        case address1 = "address_1"
        case address2 = "address_2"
        case city, state, postcode, country, email, phone
    }
}

enum CreatedVia: String, Codable {
    case checkout = "checkout"
    case restAPI = "rest-api"
}

enum Currency: String, Codable {
    case inr = "INR"
}

enum CurrencySymbol: String, Codable {
    case empty = "₹"
}

// MARK: - LineItem
struct LineItem: Codable {
    
    let productID: Int
    let quantity: Int
    //let variationID: Int
    
    enum CodingKeys: String, CodingKey {
        case productID = "product_id"
        //case variationID = "variation_id"
        case quantity
    }
}

enum PaymentMethod: String, Codable {
    case cod = "cod"
    case empty = ""
}

enum PaymentMethodTitle: String, Codable {
    case cashOnDelivery = "Cash on delivery"
    case empty = ""
}

// MARK: - ShippingLine
struct ShippingLine: Codable {
    
    let methodTitle: String
    let methodID: String
    let total: String
    
    enum CodingKeys: String, CodingKey {
        case methodTitle = "method_title"
        case methodID = "method_id"
        case total
    }
}

struct APIRequest {

    let resourceURL = URL(string: "https://webgrity.in/IOS-Testing/wp-json/wc/v3/orders?consumer_key=ck_542029bdf259fa5f5a26a27242d8fa8324f13d18&consumer_secret=cs_a4196e9ef5d0c5a8fa7015cdca7b95b4942c5c99")

    func save (_ messageToSave:orderStruct, completion: @escaping(Result<orderStruct, APIError>) -> Void) {
        
        var urlRequest = URLRequest(url: resourceURL!)
        urlRequest.httpMethod = "POST"
        //urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(messageToSave)
            urlRequest.httpBody = jsonData
        }catch let jsonErr{
            print(jsonErr)
        }

        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                   if let jsonData = data {
                       do {
                           let messageData = try JSONDecoder().decode(orderStruct.self, from: jsonData)
                           completion(.success(messageData))
                       } catch {
                           completion(.failure(.decodingProblem))
                       }
                   }
               }
        dataTask.resume()        
    }
}


class BillingAddressViewController: UIViewController, UITextFieldDelegate {
    
    var orderArray = [orderStruct]()
    var updatedOrderArray = [OrderUpdate]()
    var cartArray = [CartStruct]()
    
    var receivingString = ""
    var receivedName = ""
    
    @IBOutlet var viewCountry: UIView!
    @IBOutlet var lblCountry: UILabel!
    
    @IBOutlet var viewState: UIView!
    @IBOutlet var lblState: UILabel!
    
    @IBOutlet var txtFName: UITextField!
    @IBOutlet var txtLName: UITextField!
    @IBOutlet var txtCompany: UITextField!
    @IBOutlet var txtStreet1: UITextField!
    @IBOutlet var txtStreet2: UITextField!
    @IBOutlet var txtTown: UITextField!
    @IBOutlet var txtPin: UITextField!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var lblEmail: UILabel!
    
    @IBOutlet var placeBtn: UIButton!
    
    let dropDownC = DropDown()
    let countryArray = ["Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Côte d'Ivoire", "Cabo Verde", "Cambodia", "Cameroon", "Canada", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo (Congo-Brazzaville)", "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czechia (Czech Republic)", "Democratic Republic of the Congo", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Eswatini (fmr. Swaziland)", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Holy See", "Honduras", "Hungary", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar (formerly Burma)", "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Korea", "North Macedonia", "Norway", "Oman", "Pakistan", "Palau", "Palestine State", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russia", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Sweden", "Switzerland", "Syria", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States of America", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe"]
    
    let dropDownS = DropDown()
    let stateArray = ["Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttarakhand", "Uttar Pradesh", "West Bengal", "Andaman and Nicobar Islands", "Chandigarh", "Dadra and Nagar Haveli", "Daman and Diu", "Delhi", "Lakshadweep", "Puducherry"]
    
    /*var f_name = ""
    var l_name = ""
    var company = ""
    var st1 = ""
    var st2 = ""
    var town = ""
    var pincode = ""
    var state = ""
    var country = ""
    var ph = ""
    var mail = ""*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtFName.delegate = self
        txtLName.delegate = self
        txtCompany.delegate = self
        txtStreet1.delegate = self
        txtStreet2.delegate = self
        txtTown.delegate = self
        txtPin.delegate = self
        txtPhone.delegate = self
        txtEmail.delegate = self

        dropDownC.anchorView = viewCountry
        dropDownC.dataSource = countryArray
        dropDownC.bottomOffset = CGPoint(x: 0, y: (dropDownC.anchorView?.plainView.bounds.height)!)
        dropDownC.topOffset = CGPoint(x: 0, y:-(dropDownC.anchorView?.plainView.bounds.height)!)
        dropDownC.direction = .bottom
        dropDownC.selectionAction = { [unowned self] (index1: Int, item1: String) in
            print("Selected Month: \(item1) at index: \(index1)")
            self.lblCountry.text = countryArray[index1]
        }
        
        dropDownS.anchorView = viewState
        dropDownS.dataSource = stateArray
        dropDownS.bottomOffset = CGPoint(x: 0, y: (dropDownS.anchorView?.plainView.bounds.height)!)
        dropDownS.topOffset = CGPoint(x: 0, y:-(dropDownS.anchorView?.plainView.bounds.height)!)
        dropDownS.direction = .bottom
        dropDownS.selectionAction = { [unowned self] (index1: Int, item1: String) in
            print("Selected Month: \(item1) at index: \(index1)")
            self.lblState.text = stateArray[index1]
        }
        
        viewCountry.layer.cornerRadius = 5
        viewCountry.clipsToBounds = true
        
        viewState.layer.cornerRadius = 5
        viewState.clipsToBounds = true
        
        placeBtn.layer.cornerRadius = 25
        placeBtn.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func countryBtnTapped(_ sender: Any) {
        dropDownC.show()
    }
    
    @IBAction func stateBtnTapped(_ sender: Any) {
        dropDownS.show()
    }
    
    @objc func handleTap() {
        txtFName.resignFirstResponder()
        txtLName.resignFirstResponder()
        txtCompany.resignFirstResponder()
        txtStreet1.resignFirstResponder()
        txtStreet2.resignFirstResponder()
        txtTown.resignFirstResponder()
        txtPin.resignFirstResponder()
        txtPhone.resignFirstResponder()
        txtEmail.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return Tapped")
        txtFName.resignFirstResponder()
        txtLName.resignFirstResponder()
        txtCompany.resignFirstResponder()
        txtStreet1.resignFirstResponder()
        txtStreet2.resignFirstResponder()
        txtTown.resignFirstResponder()
        txtPin.resignFirstResponder()
        txtPhone.resignFirstResponder()
        txtEmail.resignFirstResponder()
        return true
    }
    
    @IBAction func placeBtnTapped(_ sender: Any) {
        
        for items in cartArray {
            let info = items.cartItems
            
            let lineitems = LineItem(productID: info.id, quantity: 1)
            let billingInfo = Ing(firstName: txtFName.text ?? "NA", lastName: txtLName.text ?? "NA", company: txtCompany.text ?? "NA", address1: txtStreet1.text ?? "NA", address2: txtStreet2.text ?? "NA", city: txtTown.text ?? "NA", state: self.lblState.text ?? "NA", postcode: txtPin.text ?? "NA", country:  self.lblCountry.text ?? "NA", email: txtEmail.text ?? "NA", phone: txtPhone.text ?? "NA")
            
            let shipline = ShippingLine(methodTitle: "flat_rate", methodID: "Flat Rate", total: info.price)
            
            let orderDetails = orderStruct(paymentMethod: PaymentMethod.cod.rawValue, paymentMethodTitle: PaymentMethodTitle.cashOnDelivery.rawValue, setPaid: true, billing: billingInfo, shipping: billingInfo, lineItems: [lineitems], shippingLines: [shipline])
            
            let postRequest = APIRequest()
            postRequest.save(orderDetails, completion: { result in
                switch result {
                case .success(let message):
                    print("Sent msg: \(message)")
                    self.navigateToSuccessScreen() //If success navigate to next VC
                    self.placeBtn.isUserInteractionEnabled = false
                case .failure(let error):
                    print("Error occured \(error)")
                }
            })
        }
        
    }
    
    func isValidEmail(emailID:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[]A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailID)
    }
    
    func navigateToSuccessScreen() {
        DispatchQueue.main.async {
            let done = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as? SuccessViewController
            self.navigationController?.pushViewController(done!, animated: true)
        }
    }
}
