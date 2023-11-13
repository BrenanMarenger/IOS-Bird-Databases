//
//  ViewController.swift
//  PG4
//
//  Created by NMU Student on 10/19/23.
//

import UIKit
import SQLite3

class TableViewController: UITableViewController {
    
    @IBOutlet var ivc:InfoViewController?
    var Categories:[String] = []
    var Names:[[String]] = []
    var Species:[[String]] = []
    var Diets:[[String]] = []
    var Areas:[[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ivc=storyboard!.instantiateViewController(withIdentifier: "InfoViewController") as? InfoViewController
        _ = ivc!.view
        
        tableView.register(UITableViewCell.self,forCellReuseIdentifier: "bird")
        BuildTable()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem (barButtonSystemItem: .add, target:self, action:#selector(AddBird))
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }
    
    @IBAction func AddBird () {
        print("Add New Bird Page")
    }
    
    func BuildTable() {
        Names=[]
        Categories=[]
        Species=[]
        Diets=[]
        Areas=[]
        print("Opening DB")
        let path=Bundle.main.path(forResource: "BrenanPG4", ofType: "db")
        var db:OpaquePointer? = nil
        if sqlite3_open (path,&db) != SQLITE_OK {
            print("Error opening DB")
        }
        var stmt:OpaquePointer? = nil
        sqlite3_prepare_v2(db, "select distinct Category from Birds order by Category", -1, &stmt, nil)
        
        //Build up other data fields
        while sqlite3_step(stmt)==SQLITE_ROW {
            let category=String(cString:sqlite3_column_text(stmt,0))
            Categories.append(category)
            var stmt2:OpaquePointer? = nil
            sqlite3_prepare_v2(db, "select distinct Name from Birds where Category='\(category)' order by Name", -1, &stmt2, nil)
            var birdNameArray:[String] = []
            
            while sqlite3_step (stmt2)==SQLITE_ROW {
                let b=String(cString:sqlite3_column_text(stmt2,0))
                print (b)
                birdNameArray.append (b)
            }
            sqlite3_reset(stmt2)
            sqlite3_finalize(stmt2)
            Names.append (birdNameArray)
        }
        sqlite3_reset(stmt)
        sqlite3_finalize(stmt)
        sqlite3_close (db)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        print("Made it here")
        return 4//Categories.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5//Names[section].count
    }
    
    override func tableView (_ tableView: UITableView, titleForHeaderInSection section:Int)->String? {
        return "test header"//Categories[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bird", for: indexPath)

        let row = indexPath.row
        let section = indexPath.section
        cell.textLabel!.text = "test"//Names[section][row]
        
        return cell
    }
    
    override func tableView (_ tableView:UITableView, didSelectRowAt indexPath:IndexPath) {
        let section=indexPath.section
        let row = indexPath.row
        //svc!.CLab!.text = Companies[section]
        //svc!.VLab!.text = Villains[section][row]
        navigationController!.pushViewController (ivc!,animated:true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        
        if editingStyle == .delete {
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

}


