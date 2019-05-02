//
//  EditNotesViewController.swift
//  Notepad(AbservTech)
//
//  Created by brn.developers on 3/23/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import CoreData

class EditNotesViewController: UIViewController {
   
    var firstVC:ViewController!
    
    var storedObjects:[NSManagedObject]!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var managedObjectContext:NSManagedObjectContext!
    
    @IBOutlet weak var editTextView: UITextView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        managedObjectContext = appDelegate.persistentContainer.viewContext

    }
    
   
    @IBAction func backAction(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func updateNotes(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        updateData()

        
        
    }
    func updateData(){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        fetchRequest.predicate = NSPredicate(format: "notesData = %@", firstVC.val)
        
        do{
            let test = try managedObjectContext.fetch(fetchRequest)
            let dataUpdate = test[0] as! NSManagedObject
            dataUpdate.setValue(editTextView.text, forKey: "notesData")
            do{
                try managedObjectContext.save()
            }
            catch{
                print("Data not Saved")
            }
        }
        catch{
            print(error)
        }
    }
    
    
}
