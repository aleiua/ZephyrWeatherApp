//
//  MasterViewController.swift
//  ZephyrWeatherApp
//
//  Created by A. Lynn on 11/18/14.
//  Copyright (c) 2014 Lexie Lynn. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    
    // Experimented with two different ways of adding navigation buttons
    // Storyboard IBOutlet
    @IBOutlet weak var addCityButton: UIBarButtonItem!
    
    var detailViewController: DetailViewController? = nil
    var cities = [City]()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Created edit button in code
        self.navigationItem.leftBarButtonItem = self.editButtonItem()


        //let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        //self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        if cities.count != 0 {
            let i = 0
            while (i <= cities.count) {
                let indexPath = NSIndexPath(forRow: i, inSection: 0)
                let currCell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
            
                let currCity = cities[indexPath.row]
                currCell.textLabel?.text = currCity.name
                currCell.detailTextLabel?.text = currCity.country

            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



//    func insertNewObject(sender: AnyObject) {
//        cities.insertObject(City(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }

    // MARK: - Segues

    @IBAction func addCitiesButtonTap(sender: AnyObject) {
        //let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

        var addCityPrompt = UIAlertController(title: "Add new city", message: "Enter valid city & country location", preferredStyle: .Alert)
        
        var newCityName = UITextField().text
        var newCityCountry = UITextField().text
        
        addCityPrompt.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "City"
        }
        
        addCityPrompt.addTextFieldWithConfigurationHandler { textField in
            textField.placeholder = "Country"
        }
        

        let cityTextField: UITextField? = addCityPrompt.textFields?.first as? UITextField
        let countryTextField: UITextField? = addCityPrompt.textFields?.last as? UITextField
        
        addCityPrompt.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        addCityPrompt.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            
            newCityName = cityTextField?.text
            newCityCountry = countryTextField?.text
            
            var newCity = City(name: newCityName, country: newCityCountry)
            
            self.cities.insert(newCity, atIndex: 0)
            
            
            //prepareForSegue(segue:"showDetail", sender:self)
            
            //destinationViewController.city = newCity

            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            
            self.tableView.selectRowAtIndexPath(indexPath, animated: false, scrollPosition: .Top)
            
            self.performSegueWithIdentifier("showDetail", sender: self)
            
            

        }))
        


        presentViewController(addCityPrompt, animated: true, completion: nil)
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                println("gotin")
                print(indexPath.row)
                print(cities[indexPath.row].name)
                let selectedCity = cities[indexPath.row]
                print(selectedCity.name)
                
                let destinationViewController = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                destinationViewController.detailItem = selectedCity
                destinationViewController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                destinationViewController.navigationItem.leftItemsSupplementBackButton = true
                
                destinationViewController.city = selectedCity
            }
        }
        if segue.identifier == "unwind" {
            cities.removeAtIndex(0)
            
        }

        
    }
    
    @IBAction func reset(segue: UIStoryboardSegue) {
    
    }
    
//    //    override func viewControllerForUnwindSegueAction(action: UIAlertAction, fromViewController: UIViewController, withSender sender: UIAlertController) -> UIViewController? {
//    //
//    //        var result : UIViewController? = nil
//    //
//    //        let vc = super.viewControllerForUnwindSegueAction(action, fromViewController: fromViewController, withSender: sender)
//    //        println("\(self) returns \(vc) from vc for unwind segue")
//    //        result = vc
//    //        return result
//    //    }
//    
//    override func segueForUnwindingToViewController(toViewController: UIViewController, fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
//        println("\(self) was asked for segue")
//        // can't return nil
//        return super.segueForUnwindingToViewController(toViewController, fromViewController: fromViewController, identifier: identifier!)
//    }
//    
//    @IBAction func unwind(seg:UIStoryboardSegue!) {
//        println("view controller 3 unwind is never called")
//    }
//    
//    override func canPerformUnwindSegueAction(action: Selector, fromViewController: UIViewController, withSender sender: AnyObject) -> Bool {
//        println("view controller 3 can perform is never called")
//        return false
//    }
//    
//    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
//        println("view controller 3 should perform returns true")
//        return true
//        
//    }
    

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
            return true
    }
    
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        // update the item in my data source by first removing at the from index, then inserting at the to index.
        let tempCity = cities[fromIndexPath.row]
        cities.removeAtIndex(fromIndexPath.row)
        cities.insert(tempCity, atIndex: toIndexPath.row)
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let currCity = cities[indexPath.row]
        cell.textLabel?.text = currCity.name
        cell.detailTextLabel?.text = currCity.country
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            cities.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

