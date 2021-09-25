//
//  PaymentViewController.swift
//  GarnierShop
//
//  Created by Anand Baid on 8/31/21.
//

import UIKit
import DropDown

class PaymentViewController: UIViewController {
    
    @IBOutlet var firstView: UIView!
    
    @IBOutlet var viewMonth: UIView!
    @IBOutlet var lblMonth: UILabel!
    
    @IBOutlet var viewYear: UIView!
    @IBOutlet var lblYear: UILabel!
    
    @IBOutlet var payBtn: UIButton!
    
    @IBOutlet var txtName: UITextField!
    @IBOutlet var taxtCardNo: UITextField!
    @IBOutlet var txtcvv: UITextField!
    @IBOutlet var amountToBePaid: UILabel!
    
    var receivedString = ""
    
    let dropDown1 = DropDown()
    let monthArray = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec"]
    
    let dropDown2 = DropDown()
    let yearArray = ["2021", "2022", "2023", "2024", "2025", "2026", "2027", "2028", "2029", "2030", "2031", "2032", "2033", "2034", "2035", "2036", "2037", "2038", "2039", "2040", "2041", "2042", "2043", "2044", "2045"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        amountToBePaid.text = receivedString
        payBtn.setTitle("Pay \(receivedString)", for: .normal)
        
        lblMonth.text = "Month"
        dropDown1.anchorView = viewMonth
        dropDown1.dataSource = monthArray
        dropDown1.bottomOffset = CGPoint(x: 0, y: (dropDown1.anchorView?.plainView.bounds.height)!)
        dropDown1.topOffset = CGPoint(x: 0, y:-(dropDown1.anchorView?.plainView.bounds.height)!)
        dropDown1.direction = .bottom
        dropDown1.selectionAction = { [unowned self] (index1: Int, item1: String) in
            print("Selected Month: \(item1) at index: \(index1)")
            self.lblMonth.text = monthArray[index1]
        }
        
        lblYear.text = "Year"
        dropDown2.anchorView = viewYear
        dropDown2.dataSource = yearArray
        dropDown2.bottomOffset = CGPoint(x: 0, y: (dropDown2.anchorView?.plainView.bounds.height)!)
        dropDown2.topOffset = CGPoint(x: 0, y:-(dropDown2.anchorView?.plainView.bounds.height)!)
        dropDown2.direction = .bottom
        dropDown2.selectionAction = { [unowned self] (index2: Int, item2: String) in
            print("Selected Year: \(item2) at index: \(index2)")
            self.lblYear.text = yearArray[index2]
        }
        
        
        firstView.layer.cornerRadius = 10
        firstView.clipsToBounds = true
        
        viewMonth.layer.cornerRadius = 10
        viewMonth.clipsToBounds = true
        //viewMonth.layer.borderWidth = 1
        //viewMonth.layer.borderColor = UIColor.lightGray.cgColor
        
        viewYear.layer.cornerRadius = 10
        viewYear.clipsToBounds = true
        //viewYear.layer.borderWidth = 1
        //viewYear.layer.borderColor = UIColor.lightGray.cgColor
        
        payBtn.layer.cornerRadius = 30
        payBtn.clipsToBounds = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        //txtName.layer.borderWidth = 1
        //txtName.layer.borderColor = UIColor.lightGray.cgColor
        
        //taxtCardNo.layer.borderWidth = 1
        //taxtCardNo.layer.borderColor = UIColor.lightGray.cgColor
        
        //txtcvv.layer.borderWidth = 1
        //txtcvv.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func showMonthsBtn(_ sender: Any) {
        dropDown1.show()
    }
    
    @IBAction func showYearsBtn(_ sender: Any) {
        dropDown2.show()
    }
    
    @objc func handleTap() {
        txtName.resignFirstResponder()
        taxtCardNo.resignFirstResponder()
        txtcvv.resignFirstResponder()
    }

}
