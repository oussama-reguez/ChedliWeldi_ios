//
//  FiltreViewController.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 09/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import PopupDialog
class FiltreViewController: UIViewController {
    
    
    // MARK: Private
    // We will use this instead to reference our
    // controllers view instead of `view`
    @IBOutlet weak var range: UISlider!
    @IBOutlet weak var vale: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
                // Do any additional setup after loading the view.
        vale.text = "\(Int(range.value)) Km"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sliderValueChanged(sender: UISlider) {
        var currentValue = Int(sender.value)
        vale.text = "\(currentValue) Km"
    }
    
    public func getVal() -> Int{
        return Int(range.value)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
