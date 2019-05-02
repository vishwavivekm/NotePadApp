//
//  AddNotesViewController.swift
//  Notepad(AbservTech)
//
//  Created by brn.developers on 3/23/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import CoreData

class AddNotesViewController: UIViewController {

    var appDelegate:AppDelegate!
    var managedObject = [NSManagedObject]()
    var managedObjectContext:NSManagedObjectContext!
    var noteEntity = NSEntityDescription()
    
    @IBOutlet weak var notesText: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        noteEntity = NSEntityDescription.entity(forEntityName: "Notes", in: managedObjectContext)!
        
    }
    
    func saveData(){
    
        let managedObject = NSManagedObject(entity: noteEntity, insertInto: managedObjectContext)
        managedObject.setValue(notesText.text, forKey: "notesData")
        
        do{
            try managedObjectContext.save()
            print("Data Saved Successfully")
        }
        catch{
            print("Unable to Save the Data")
        }
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func saveData(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        saveData()
        
        
    }

}
