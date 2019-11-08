//
//  ViewController.swift
//  sqlTutorial
//
//  Created by aanvi on 11/2/19.
//  Copyright © 2019 aanvi. All rights reserved.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    var db: OpaquePointer?

    
    @IBOutlet weak var inputPennies: UITextField!
    
    
    @IBOutlet weak var inputNickels: UITextField!
    
    @IBOutlet weak var inputDimes: UITextField!
    
    @IBOutlet weak var inputQuarters: UITextField!
    
    
    @IBOutlet weak var inputFifties: UITextField!
    
    
    @IBAction func insertCoinCount(_ sender: Any) {
        let p = inputPennies.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let n = inputNickels.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let d = inputDimes.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let q = inputQuarters.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let f = inputFifties.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(p?.isEmpty)!{
            print("empty pennies")
            return;
        }
        
        if(n?.isEmpty)!{
            print("empty nickels")
            return
        }
        
        if(d?.isEmpty)!{
            print("empty dimes")
            return;
        }
        
        if(q?.isEmpty)!{
            print("empty quarters")
            return;
        }
        
        if(f?.isEmpty)!{
            print("empty fifties")
            return;
        }
        
        var statementInsert: OpaquePointer?
        
        let insertCoinCount = "INSERT INTO countHistory (numPennies,numNickels,numDimes,numQuarters,numFifties) VALUES (?,?,?,?,?)"
        
        if sqlite3_prepare(db,insertCoinCount,-1,&statementInsert,nil) != SQLITE_OK{
            print("error binding query")
        }
        
        if sqlite3_bind_int(statementInsert,1,(p! as NSString).intValue) != SQLITE_OK{
            print("error binding pennies")
        }
        
        if sqlite3_bind_int(statementInsert,2,(n! as NSString).intValue) != SQLITE_OK{
            print("error binding nickels")
        }
        
        if sqlite3_bind_int(statementInsert,3,(d! as NSString).intValue) != SQLITE_OK{
            print("error binding dimes")
        }
        
        if sqlite3_bind_int(statementInsert,4,(q! as NSString).intValue) != SQLITE_OK{
            print("error binding quarters")
        }
        
        if sqlite3_bind_int(statementInsert,5,(f! as NSString).intValue) != SQLITE_OK{
            print("error binding fifties")
        }
        
        if sqlite3_step(statementInsert) == SQLITE_DONE{
            print("inserted successfully")
        }
        
    }
    
    
    @IBAction func viewCT(_ sender: Any) {
        
        let selectQuery = "SELECT * FROM countHistory"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db,selectQuery,-1,&stmt,nil) == SQLITE_OK{
            print("Query Result: ")
            while sqlite3_step(stmt) == SQLITE_ROW{
                let penny = sqlite3_column_int(stmt,1)
                let nickel = sqlite3_column_int(stmt,2)
                let dime = sqlite3_column_int(stmt,3)
                let quarter = sqlite3_column_int(stmt,4)
                let fifty = sqlite3_column_int(stmt,5)
                
                print("\(penny) | \(nickel) | \(dime) | \(quarter) | \(fifty)")
            }
        }else{
            print("error in preparing statement")
        }
        
        sqlite3_finalize(stmt)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fileUrl = try!
            FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("CoinDB.sqlite")
        
        if sqlite3_open(fileUrl.path,&db) != SQLITE_OK{
            print("error opening db")
            
        }
        
        let createCTH = "CREATE TABLE IF NOT EXISTS countHistory (id INTEGER PRIMARY KEY AUTOINCREMENT, numPennies INTEGER, numNickels INTEGER, numDimes INTEGER, numQuarters INTEGER, numFifties INTEGER)"
        
        if sqlite3_exec(db,createCTH,nil,nil,nil) != SQLITE_OK{
            print("error creating count history table")
            return
        }
        
        let createCET = "CREATE TABLE IF NOT EXISTS exchangeRates(code TEXT PRIMARY KEY UNIQUE, amtInDollar NUMERIC)"
        
        if sqlite3_exec(db, createCET, nil, nil, nil) != SQLITE_OK{
            print("error creating exchange rate table")
        }
    
        
        let insertEV = "INSERT INTO exchangeRates (code, amtInDollar) VALUES (EUR, 0.9),(GBP, 0.77), (MXN, 19.11)"
        
        if sqlite3_exec(db, insertEV,nil,nil,nil) != SQLITE_OK{
            print("error inserting exchange rate vals")
        }
        
        print("Everything is fine!")
        
    }


}

