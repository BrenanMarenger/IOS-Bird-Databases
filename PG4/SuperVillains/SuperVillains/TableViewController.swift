//
//  TableViewController.swift
//  PG4Final
//
//  Created by Brenan Marenger on 10/23/23.
//


import UIKit
import SQLite3

class TableViewController: UITableViewController {
    
    @IBOutlet var svc:SecondViewController?
    @IBOutlet var tvc:ThirdViewController?
    
    var Categories:[String] = []
    var Names:[[String]] = []
    var Species:[[String]] = []
    var Diets:[[String]] = []
    var Areas:[[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        svc = storyboard!.instantiateViewController(withIdentifier:"SecondViewController") as? SecondViewController
        _ = svc!.view
        
        tvc = storyboard!.instantiateViewController(withIdentifier:"ThirdViewController") as? ThirdViewController
        _ = tvc!.view
        
        tableView.register (UITableViewCell.self,forCellReuseIdentifier:"bird")
        BuildArrays ()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem (barButtonSystemItem: .add, target:self, action:#selector(AddStuff))
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @objc func AddStuff () {
        navigationController!.pushViewController (tvc!,animated:true)
        tvc!.submitButton?.addTarget(self, action: #selector(makeBird), for: .touchUpInside)
    }
    
    @IBAction func makeBird(){
        var newCategory:String? = tvc!.categoryTF?.text
        var newName:String?  = tvc!.nameTF?.text
        var newArea:String?  = tvc!.areaTF?.text
        var newDiet:String?  = tvc!.dietTF?.text
        var newSpecies:String?  = tvc!.speciesTF?.text
        
        let path=Bundle.main.path(forResource:"BrenanPG4",ofType:"db")
        var db:OpaquePointer? = nil
        if sqlite3_open (path,&db) != SQLITE_OK {
            print ("Error opening database")
        }
        var stmt:OpaquePointer? = nil
        sqlite3_prepare_v2 (db,"INSERT INTO Birds(Name,Category,Species,Area,Diet) VALUES ('\(newName!)','\(newCategory!)','\(newSpecies!)','\(newArea!)','\(newDiet!)')",-1,&stmt,nil)
        print("INSERT INTO Birds(Name,Category,Species,Area,Diet) VALUES (\(newName!),\(newCategory!),\(newSpecies!),\(newArea!),\(newDiet!))")
        while sqlite3_step (stmt)==SQLITE_ROW {}
        sqlite3_reset(stmt)
        sqlite3_finalize(stmt)
        sqlite3_close (db)
        BuildArrays ()
        tableView!.reloadData()
    }
    
    func BuildArrays () {
        Names=[]
        Categories=[]
        Species=[]
        Diets=[]
        Areas=[]
        let path=Bundle.main.path(forResource:"BrenanPG4",ofType:"db")
        var db:OpaquePointer? = nil
        if sqlite3_open (path,&db) != SQLITE_OK {
            print ("Error opening database")
        }
        var stmt:OpaquePointer? = nil
        sqlite3_prepare_v2 (db,"select distinct Category from Birds order by Category",-1,&stmt,nil)

        while sqlite3_step (stmt)==SQLITE_ROW {
            let category=String(cString:sqlite3_column_text(stmt,0))
            
            Categories.append(category)
            
            birdDataPopulator("Name", category)
            birdDataPopulator("Area", category)
            birdDataPopulator("Diet", category)
            birdDataPopulator("Species", category)
            
        }
        sqlite3_reset(stmt)
        sqlite3_finalize(stmt)
        sqlite3_close (db)
    }
    
    func birdDataPopulator(_ infoType:String,_ category:String) {
        let path=Bundle.main.path(forResource:"BrenanPG4",ofType:"db")
        var db2:OpaquePointer? = nil
        if sqlite3_open (path,&db2) != SQLITE_OK {
            print ("Error opening database")
        }

        var stmt2:OpaquePointer? = nil
        sqlite3_prepare_v2 (db2,"select \(infoType) from Birds where Category='\(category)' order by Name",-1,&stmt2,nil)
        var tempArray:[String] = []
        while sqlite3_step (stmt2)==SQLITE_ROW {
            let b=String(cString:sqlite3_column_text(stmt2,0))
            print (b)
            tempArray.append (b)
        }
        sqlite3_reset(stmt2)
        sqlite3_finalize(stmt2)
        if (infoType == "Name"){
            Names.append(tempArray)
        } else if (infoType == "Area"){
            Areas.append(tempArray)
        } else if (infoType == "Diet"){
            Diets.append(tempArray)
        } else if (infoType == "Species"){
            Species.append(tempArray)
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return Categories.count //the size of the array
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Names[section].count
    }

    override func tableView (_ tableView: UITableView, titleForHeaderInSection section:Int)->String? {
        return Categories[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bird", for: indexPath)
        let row = indexPath.row
        let section = indexPath.section
        cell.textLabel!.text = Names[section][row]
        
        return cell
    }
     
    override func tableView (_ tableView:UITableView, didSelectRowAt indexPath:IndexPath) {
        let section=indexPath.section
        let row = indexPath.row
        svc!.CLab!.text = Categories[section]
        svc!.VLab!.text = Names[section][row]
        svc!.ALab!.text = Areas[section][row]
        svc!.SLab!.text = Species[section][row]
        svc!.DLab!.text = Diets[section][row]
        
        navigationController!.pushViewController (svc!,animated:true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = indexPath.section
        if editingStyle == .delete {
            let path=Bundle.main.path(forResource:"BrenanPG4",ofType:"db")
            var db:OpaquePointer? = nil //Pointer to anything
            if sqlite3_open (path,&db) != SQLITE_OK {
                print ("Error opening database")
            }
            var stmt:OpaquePointer? = nil
            sqlite3_prepare_v2 (db,"DELETE FROM Birds WHERE Category = '\(Categories[section])' AND Name = '\(Names[section][row])'",-1,&stmt,nil)
            while sqlite3_step (stmt)==SQLITE_ROW {
            }
            sqlite3_reset(stmt)
            sqlite3_finalize(stmt)
            sqlite3_close (db)
            BuildArrays ()
            tableView.reloadData()
        }
    }
}
