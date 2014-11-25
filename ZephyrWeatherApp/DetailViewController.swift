//
//  DetailViewController.swift
//  ZephyrWeatherApp
//
//  Created by A. Lynn on 11/18/14.
//  Copyright (c) 2014 Lexie Lynn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    //var city: City!
    var urlSession: NSURLSession!
    var weatherData: NSDictionary!


    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var weatherDescriptionTextView: UITextView!
    

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBAction func unwindToThisViewController(segue: UIStoryboardSegue) {
    }
    
    

//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        // Custom initialization
//    }

//    required init(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    required init(coder aDecoder: NSCoder)
//    {
//        super.init(coder: aDecoder);
//    }
    
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
            
        }
    }

    var city: City? = nil {
        didSet {
            if isViewLoaded() {
                getWeatherData()
            }
        }
    }
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: AnyObject = self.detailItem {
            if let label = self.detailDescriptionLabel {
                //label.text = detail.description
                label.text = city!.name
            }
        }
    }
    


    override func viewDidLoad() {
        self.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem()
        
        //self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background"))
        
        super.viewDidLoad()
        
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        urlSession = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: NSOperationQueue.mainQueue())
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true

        
        if city != nil {
            getWeatherData()
        }
        //self.configureView()
        // Do any additional setup after loading the view, typically from a nib.

        

    }
    
//    func segueForUnwindingToViewController(MasterViewController: UIViewController,
//        fromViewController DetailViewController: UIViewController,
//        identifier backToMainSegue: String?) -> UIStoryboardSegue {
//            
//    }
//    
    
    
    
    func getWeatherData() {
        
        var cityName: String = city!.name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        print(cityName)
        let url = NSURL(string: "http://api.openweathermap.org/data/2.5/weather?q=" + cityName + "&APPID=2e8324b4b0e84cff23668563c4af3d29&units=imperial")
        
        print(url)
        
        
        
        let dataTask = urlSession.dataTaskWithURL(url, completionHandler: { data, response, error in
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            print(responseString)

            
            
            
            if let weatherData = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as? NSDictionary {
                print("indaif")
                
                if let message = weatherData["message"] as? String {
                    var alertController = UIAlertController(title: "Error", message: message, preferredStyle: .Alert)
    
                    
                    let VC :UIViewController = self

                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in

                        // I tried everything I could think of to unwind back to the master view controller
                        // when catchng an invalid city error. Unfortunately, I could not get it to work. 
                        // I was able to build an unwind segue from a button, but I coudn't get it to work from
                        // the alert controller. I also tried dismissing/popping navigation controllers which also
                        // failed to work. 
                        
                        
                        
                        // self.segueForUnwindingToViewController (toViewController: UIViewController,
                        
                        VC.performSegueWithIdentifier("unwind", sender: self)
                        
                        //self.navigationItem.leftBarButtonItem?.select(self.navigationController)
                        //self.dismissViewControllerAnimated(true, completion: nil)
                        
                        //self.navigationController.dismissViewControllerAnimated(false)
                        
                        //self.navigationController?.popViewControllerAnimated(true)
                        
                        
                        return
                    } )

                    
                    alertController.addAction(OKAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)

                }
                
                
                self.weatherData = weatherData as NSDictionary
                
                
                if let mainDict = weatherData["weather"] as? [NSDictionary] {
                    println("it worked *&*&*")
                    
                    let imageName = mainDict[0]["icon"] as String
                    let image = UIImage(named: imageName)
                    self.weatherImage.image = image
                    
                    let description = mainDict[0]["description"] as String
                    self.weatherDescriptionTextView.text = description
                    
                }
                
                if let tempDict = weatherData["main"] as? NSDictionary {
                    println("this worked tooo")
                    
                    let temp = tempDict["temp"] as NSNumber
                    let tempString = "\(temp.doubleValue)"
                    self.currentTempLabel.text = tempString
                    
                    let highTemp = tempDict["temp_max"] as NSNumber
                    let highTempString = "\(highTemp.doubleValue)"
                    self.highTempLabel.text = highTempString
                    
                    let lowTemp = tempDict["temp_min"] as NSNumber
                    let lowTempString = "\(lowTemp.doubleValue)"
                    self.lowTempLabel.text = lowTempString
                }
            }
            
        })
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        dataTask.resume()
        
    }
    
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if city != nil {
            navigationItem.title = city!.name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

