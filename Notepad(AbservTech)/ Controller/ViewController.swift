//
//  ViewController.swift
//  Notepad(AbservTech)
//
//  Created by brn.developers on 3/23/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var appDelegate = AppDelegate()
    var managedObjectContext:NSManagedObjectContext!
    var storedObjects:[NSManagedObject]!
    var notesData:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var val:String!
    var noteArray:[String] = []
    
    var editVC:EditNotesViewController!
    
    @IBOutlet weak var notesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesTableView.rowHeight = 50
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedObjectContext = appDelegate.persistentContainer.viewContext
        
        notesTableView.tableFooterView = UIView.init(frame: .zero)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        notesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = notesTableView.dequeueReusableCell(withIdentifier: "abcd", for: indexPath)
        cell.textLabel?.text = noteArray[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        editVC = self.storyboard?.instantiateViewController(withIdentifier: "EditNotesViewController") as? EditNotesViewController
        
        
        editVC.firstVC = self
        
        self.present(editVC, animated: true) {
            self.editVC.editTextView?.text = self.noteArray[indexPath.row]
            self.val = self.editVC.editTextView.text
            
        }
        
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "DELETE") { (action, Indexpath) in
            
            let fetchRequest:NSFetchRequest<Notes> = Notes.fetchRequest()
            
            fetchRequest.predicate = NSPredicate(format: "notesData = %@", self.noteArray[indexPath.row])
            
            var fetchItems = [Notes]()
            do{
                fetchItems = try self.managedObjectContext.fetch(fetchRequest)
            }catch{
                print("Could not Fetch")
            }
            
            for item in fetchItems{
                self.managedObjectContext.delete(item)
                print("Item Deleted")
            }
            do{
                try self.managedObjectContext.save()
            }
            catch{
                print("Unable to Update")
            }
            self.fetchData()
            self.notesTableView.reloadData()
            //            self.notesTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        }
        
        
        let cancelAction = UITableViewRowAction.init(style: .normal, title: "Cancel") { (rowAction, IndexPath) in
            print("cancel")
        }
        delteAction.backgroundColor = #colorLiteral(red: 1, green: 0.06543179506, blue: 0, alpha: 1)
        cancelAction.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return [cancelAction, delteAction]
        
    }
    
    
    
    @IBAction func addNotes(_ sender: Any) {
        
        var addNotesVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNotesViewController") as! AddNotesViewController
        
        present(addNotesVC, animated: true, completion: nil)
        
        
    }
    
    func fetchData(){
        
        let dataFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
        noteArray.removeAll()
        
        do{
            storedObjects = try managedObjectContext.fetch(dataFetch) as? [NSManagedObject]
            for i in 0..<storedObjects.count{
                
                let managedObject:NSManagedObject = storedObjects[i]
                noteArray.append(managedObject.value(forKey: "notesData") as! String)
                //print(noteArray)
            }
        }
        catch{
            print("Data Retrieval Unsuccessful")
        }
        
        
        
    }
    
    
    
}

