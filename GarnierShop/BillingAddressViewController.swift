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

struct APIRequest {
    //let resourceURL: URL
    

    //let resourceString = "https://webgrity.in/IOS-Testing/wp-json/wc/v3/orders?consumer_key=ck_542029bdf259fa5f5a26a27242d8fa8324f13d18&consumer_secret=cs_a4196e9ef5d0c5a8fa7015cdca7b95b4942c5c99"
    let resourceURL = URL(string: "https://webgrity.in/IOS-Testing/wp-json/wc/v3/orders?consumer_key=ck_542029bdf259fa5f5a26a27242d8fa8324f13d18&consumer_secret=cs_a4196e9ef5d0c5a8fa7015cdca7b95b4942c5c99")
        
    //self.resourceURL = resourceURL
    
    
    func save (_ messageToSave:Billing, completion: @escaping(Result<Billing, APIError>) -> Void) {
        do {
            var urlRequest = URLRequest(url: resourceURL!)
            urlRequest.httpMethod = "POST"
            //urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(messageToSave)
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, _ in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let jsonData = data else {
                    completion(.failure(.responseProblem))
                    return
                }
                
                do {
                    let messageData = try JSONDecoder().decode(Billing.self, from: jsonData)
                    completion(.success(messageData))
                } catch {
                    completion(.failure(.decodingProblem))
                }
            }
            dataTask.resume()
        } catch {
            completion(.failure(.encodingProblem))
        }
    }
}

struct orderStruct: Codable {
    let billing: Billing
    let shipping: Shipping
    
    enum CodingKeys: String, CodingKey {
        case billing
        case shipping
    }
}

struct Billing: Codable {
    let txtFName: String
    let txtLName: String
    let txtCompany: String
    let txtStreet1: String
    let txtStreet2: String
    let txtTown: String
    let txtPin: String
    let txtPhone: String
    let txtEmail: String
    let lblState: String
    let lblCountry: String
    
    enum  CodingKeys: String, CodingKey {
        case txtFName = "first_name"
        case txtLName = "last_name"
        case txtCompany = "company"
        case txtStreet1 = "address_1"
        case txtStreet2 = "address_2"
        case txtTown = "city"
        case txtPin = "postcode"
        case txtPhone = "phone"
        case txtEmail = "email"
        case lblState = "state"
        case lblCountry = "country"
    }
    
    init(txtFName: String, txtLName: String, txtCompany: String, txtStreet1: String, txtStreet2: String, txtTown: String, txtPin: String, txtPhone: String, txtEmail: String, lblState: String, lblCountry: String){
        self.txtFName = txtFName
        self.txtLName = txtLName
        self.txtCompany = txtCompany
        self.txtStreet1 = txtStreet1
        self.txtStreet2 = txtStreet2
        self.txtTown = txtTown
        self.txtPin = txtPin
        self.txtPhone = txtPhone
        self.txtEmail = txtEmail
        self.lblState = lblState
        self.lblCountry = lblCountry
    }
    
    /*func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(txtFName, forKey: .txtFName)
        try container.encode(txtLName, forKey: .txtLName)
        try container.encode(txtCompany, forKey: .txtCompany)
        try container.encode(txtStreet1, forKey: .txtStreet1)
        try container.encode(txtStreet2, forKey: .txtStreet2)
        try container.encode(txtTown, forKey: .txtTown)
        try container.encode(txtPin, forKey: .txtPin)
        try container.encode(txtPhone, forKey: .txtPhone)
        try container.encode(txtEmail, forKey: .txtEmail)
        try container.encode(lblState, forKey: .lblState)
        try container.encode(lblCountry, forKey: .lblCountry)
    }*/
}

struct Shipping: Codable {
    let txtFName: String
    let txtLName: String
    let txtCompany: String
    let txtStreet1: String
    let txtStreet2: String
    let txtTown: String
    let txtPin: String
    let txtPhone: String
    let lblState: String
    let lblCountry: String
    
    enum  CodingKeys: String, CodingKey {
        case txtFName = "first_name"
        case txtLName = "last_name"
        case txtCompany = "company"
        case txtStreet1 = "address_1"
        case txtStreet2 = "address_2"
        case txtTown = "city"
        case txtPin = "postcode"
        case txtPhone = "phone"
        case lblState = "state"
        case lblCountry = "country"
    }
}


class BillingAddressViewController: UIViewController {
    
    var orderArray = [orderStruct]()
    /*var billingArray = Billing(txtFName: "Ahana", txtLName: "Chakraborty", txtCompany: "X", txtStreet1: "asd", txtStreet2: "frnfvv", txtTown: "Utp", txtPin: "712245", txtPhone: "23423234432", txtEmail: "a@gmail.com", lblState: "WB", lblCountry: "Ind")*/
    var billingArray: Billing?
    var shippingArray: Shipping?
    
    var updatedOrderArray = [OrderUpdate]()
    
    
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
    
    @IBOutlet var placeBtn: UIButton!
    
    
    let dropDownC = DropDown()
    let countryArray = ["Afghanistan", "Albania", "Algeria", "Andorra", "Angola", "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria", "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin", "Bhutan", "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei", "Bulgaria", "Burkina Faso", "Burundi", "Côte d'Ivoire", "Cabo Verde", "Cambodia", "Cameroon", "Canada", "Central African Republic", "Chad", "Chile", "China", "Colombia", "Comoros", "Congo (Congo-Brazzaville)", "Costa Rica", "Croatia", "Cuba", "Cyprus", "Czechia (Czech Republic)", "Democratic Republic of the Congo", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Eswatini (fmr. Swaziland)", "Ethiopia", "Fiji", "Finland", "France", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Greece", "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Holy See", "Honduras", "Hungary", "India", "Indonesia", "Iran", "Iraq", "Ireland", "Israel", "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan", "Kenya", "Kiribati", "Kuwait", "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg", "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius", "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia", "Montenegro", "Morocco", "Mozambique", "Myanmar (formerly Burma)", "Namibia", "Nauru", "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger", "Nigeria", "North Korea", "North Macedonia", "Norway", "Oman", "Pakistan", "Palau", "Palestine State", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines", "Poland", "Portugal", "Qatar", "Romania", "Russia", "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa", "San Marino", "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa", "South Korea", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname", "Sweden", "Switzerland", "Syria", "Tajikistan", "Tanzania", "Thailand", "Timor-Leste", "Togo", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom", "United States of America", "Uruguay", "Uzbekistan", "Vanuatu", "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe"]
    
    let dropDownS = DropDown()
    let stateArray = ["Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chhattisgarh", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Odisha", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttarakhand", "Uttar Pradesh", "West Bengal", "Andaman and Nicobar Islands", "Chandigarh", "Dadra and Nagar Haveli", "Daman and Diu", "Delhi", "Lakshadweep", "Puducherry"]
    
    var f_name = ""
    var l_name = ""
    var company = ""
    var st1 = ""
    var st2 = ""
    var town = ""
    var pincode = ""
    var state = ""
    var country = ""
    var ph = ""
    var mail = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //txtFName.text = f_name

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
        
        let message = Billing(txtFName: f_name, txtLName: l_name, txtCompany: company, txtStreet1: st1, txtStreet2: st2, txtTown: town, txtPin: pincode, txtPhone: ph, txtEmail: mail, lblState: state, lblCountry: country)
        let postRequest = APIRequest()
        postRequest.save(message, completion: { result in
            switch result {
            case .success(let message):
                print("Sent msg: \(message.txtFName)")
            case .failure(let error):
                print("Error occured \(error)")
            }
        })
    }
    
    /*func getOrder() {
     
        /*let url = URL(string: "https://webgrity.in/IOS-Testing/wp-json/wc/v3/orders?consumer_key=ck_542029bdf259fa5f5a26a27242d8fa8324f13d18&consumer_secret=cs_a4196e9ef5d0c5a8fa7015cdca7b95b4942c5c99/post")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{if error == nil{
                let data = try JSONEncoder().encode(self.orderArray)
                print(String(data: data, encoding: .utf8)!)

                    print(self.orderArray)
                    //DispatchQueue.main.async {
                         //self.tableView.reloadData()
                    //}
                }
            }catch{
                print("Error in get json data json")
            }
        }.resume()*/
        
        
        /*guard let uploadData = try? JSONEncoder().encode([orderStruct]) else {
            return
        }*/
        
        let url = URL(string: "https://webgrity.in/IOS-Testing/wp-json/wc/v3/orders?consumer_key=ck_542029bdf259fa5f5a26a27242d8fa8324f13d18&consumer_secret=cs_a4196e9ef5d0c5a8fa7015cdca7b95b4942c5c99")!
        
        AF.request(url, method:.post, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in [orderStruct].self
            
            /*let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard data != nil else { return }
                
                do {
                    let postsData = try JSONEncoder().encode([self.orderArray].self)
                    
                    //completionHandler(postsData)
                }
                catch {
                    let error = error
                    print(error.localizedDescription)
                }
                
            }.resume()*/

              //if let JSON = response.value {
                  //let dict: [String: Any] = JSON as! [String: Any]

                  //if dict["success"] as! Int == 1{
                     //print("successValue:",dict)
                  //}
                  //else{
                     //print("ErrorValue:",dict)
                 //}
                

              //}
              
          }
        
        /*var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                print ("server error")
                return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data,
                let dataString = String(data: data, encoding: .utf8) {
                print ("got data: \(dataString)")
            }
        }
        task.resume()*/
    }*/

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
    
    @IBAction func placeBtnTapped(_ sender: Any) {
        //getOrder()
        
        let done = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as? SuccessViewController
        self.navigationController?.pushViewController(done!, animated: true)
    }
    
}
