//
//  ThirdViewController.swift
//  PG4Final
//
//  Created by Brenan Marenger on 10/23/23.
//

import UIKit

class ThirdViewController: UIViewController {
    @IBOutlet var categoryTF:UITextField?
    @IBOutlet var nameTF:UITextField?
    @IBOutlet var speciesTF:UITextField?
    @IBOutlet var dietTF:UITextField?
    @IBOutlet var areaTF:UITextField?
    @IBOutlet var submitButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func Return () {
        
        view.removeFromSuperview()
    }
}
