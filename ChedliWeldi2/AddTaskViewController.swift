//
//  AddTaskViewController.swift
//  ChedliWeldi2
//
//  Created by Mohamed Taha Douiri on 07/01/2018.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import os.log


class AddTaskViewController: UIViewController,UITextFieldDelegate{
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var txtTaskName: UITextField!
    @IBOutlet weak var txtTaskDesc: UITextView!
    @IBOutlet weak var txtFrom: UITextField!
    @IBOutlet weak var txtTo: UITextField!
    public var task : Task?
    override func viewDidLoad() {
        super.viewDidLoad()
        txtTaskName.delegate = self
        txtFrom.delegate = self
        txtTo.delegate = self
        updateSaveButtonState()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let name = txtTaskName.text ?? ""
        let desc = txtTaskDesc.text ?? ""
        let from = txtFrom.text ?? ""
        let to = txtTo.text ?? ""
        
        task = Task(name:name,desc:desc,from:from,to:to)
        
        
    }
    
     func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        if(textField == txtTaskName){
            navigationItem.title = textField.text
        }
    }
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let name = txtTaskName.text ?? ""
        let desc = txtTaskDesc.text ?? ""
        let from = txtFrom.text ?? ""
        let to = txtTo.text ?? ""
        if(name.isEmpty||desc.isEmpty||from.isEmpty||to.isEmpty){
            saveButton.isEnabled = false
        }
        else {
            saveButton.isEnabled = true
        }
    }

}
