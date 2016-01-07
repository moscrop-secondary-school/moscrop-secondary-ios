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
    
    enum ThemeType {
        case Light
        case Dark
        case Black
        case TransparentBlack
    }
    var selected = ThemeType.Light
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        lightRadioButton.selected = true
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
