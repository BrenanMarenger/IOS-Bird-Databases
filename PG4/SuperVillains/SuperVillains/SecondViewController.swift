//
//  SecondViewController.swift
//  PG4Final
//
//  Created by Brenan Marenger on 10/23/23.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet var CLab:UILabel?
    @IBOutlet var VLab:UILabel?
    @IBOutlet var ALab:UILabel?
    @IBOutlet var SLab:UILabel?
    @IBOutlet var DLab:UILabel?
    
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
