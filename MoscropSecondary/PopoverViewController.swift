//
//  PopoverViewController.swift
//  
//
//  Created by Jason Wong on 2016-01-07.
//
//

import UIKit

class PopoverViewController: UIViewController {

    @IBOutlet var lightRadioButton: DLRadioButton!
    
    @IBOutlet var darkRadioButton: DLRadioButton!
    
    @IBOutlet var blackRadioButton: DLRadioButton!
    
    @IBOutlet var transRadioButton: DLRadioButton!
    
    var defaults = NSUserDefaults.standardUserDefaults()
    
    var theme = ThemeType.Light.rawValue
    
    @IBAction func lightAction(sender: AnyObject) {
        theme = ThemeType.Light.rawValue
        defaults.setObject(theme, forKey: "Theme")
        defaults.synchronize()
    }
    
    @IBAction func darkAction(sender: AnyObject) {
        theme = ThemeType.Dark.rawValue
        defaults.setObject(theme, forKey: "Theme")
        defaults.synchronize()
    }
    
    
    @IBAction func blackAction(sender: AnyObject) {
        theme = ThemeType.Black.rawValue
        defaults.setObject(theme, forKey: "Theme")
        defaults.synchronize()
    }
    
    @IBAction func transAction(sender: AnyObject) {
        theme = ThemeType.TransparentBlack.rawValue
        defaults.setObject(theme, forKey: "Theme")
        defaults.synchronize()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        
        if (defaults.objectForKey("Theme") != nil) {
            theme = defaults.stringForKey("Theme")!
        }
        switch theme {
        case "Light":
            lightRadioButton.selected = true
        case "Dark":
            darkRadioButton.selected = true
        case "Black":
            blackRadioButton.selected = true
        case "Trans":
            transRadioButton.selected = true
        default:
            theme = ThemeType.Light.rawValue
            lightRadioButton.selected = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
