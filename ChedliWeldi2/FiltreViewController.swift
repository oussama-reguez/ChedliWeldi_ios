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
    public weak var popup: PopupDialog?
    
    public fileprivate(set) var selectedCity: String?
    
    // MARK: Private
    // We will use this instead to reference our
    // controllers view instead of `view`
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the dialog (custom) title
        let txt = UITextView()
        txt.text="hello"
        self.view.addSubview(txt)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
