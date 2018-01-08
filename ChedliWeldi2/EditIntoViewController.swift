//
//  EditIntoViewController.swift
//  ChedliWeldi2
//
//  Created by oussama reguez on 1/8/18.
//  Copyright © 2018 Esprit. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import SwiftyJSON

class EditIntoViewController: UIViewController ,  UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    @IBOutlet weak var photo: UIImageView!
    var imagePicker = UIImagePickerController()
    var imagePicked = 0

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        uploadImage(userId: AppDelegate.userId)
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
        
    }

    @IBAction func onClick(_ sender: UIButton) {
        
        
        var strDate:String="1993-03-23"
        var strGender:String="1"
        if(gender.selectedSegmentIndex==1){
            strGender="0"
        }
        update(idUser: AppDelegate.userId, firstName: firstName.text!, lastName: lastName.text!, phoneNumber: phoneNumber.text!, birthDate: strDate, isMale: strGender)
    }
    @IBOutlet weak var gender: UISegmentedControl!
    @IBOutlet weak var birthDate: SkyFloatingLabelTextField!
    @IBOutlet weak var phoneNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var lastName: SkyFloatingLabelTextField!
    @IBOutlet weak var firstName: SkyFloatingLabelTextField!
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
     //   let tappedImage = tapGestureRecognizer.view as! UIImageView
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum){
            
            present(imagePicker, animated: true)
        }
        // Your action
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        photo.isUserInteractionEnabled = true
        photo.addGestureRecognizer(tapGestureRecognizer)
        
        
        
        getUserInfo(idUser: AppDelegate.userId)
        
        

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
    
    
    var image:UIImage? = nil
    func uploadImage(userId:String){
        
        
        let myUrl = URL(string: AppDelegate.serverUrl+"uploadUserPhoto");
        let imageData = UIImageJPEGRepresentation(self.image!, 1)
        let strBase64 = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
        
        if(imageData==nil)  { return; }
        
        let params : Dictionary = [
            "image_path" : strBase64,
            "user_id" : userId
        ]
        
        Alamofire.request(myUrl!, method: .post , parameters: params).validate()
            .responseData { response in
                
                switch response.result {
                    
                case .success:
                    print("Validation Successful")
                    
                    // Print out reponse body
                    let responseString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                    print("**** response data = \(responseString!)")
                    
                   self.photo.image=self.image
                    
                    
                    
                case .failure(let error):
                    print(error)
                }
        }}
    
    
    func getUserInfo(idUser:String)   {
        Alamofire.request(AppDelegate.serverUrl+"getAccountInfo", method: .post , parameters: ["id_user": idUser])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    
                    
                    
                    let data = JSON(data: json)
                    let error = data["error"].boolValue
                    if(error){
                        
                        return
                    }
                    
                    let user = data["user"]
                    
                    let url = URL(string: AppDelegate.serverImage + user["photo"].stringValue)
                    self.photo.kf.setImage(with: url)
                    //self.userId=offer["id_user"].stringValue
                    
                    self.firstName.text=user["firstName"].stringValue
                    self.lastName.text=user["lastName"].stringValue
                    self.phoneNumber.text=user["phoneNumber"].stringValue
                    self.birthDate.text=user["birthDate"].stringValue
                    let g=user["isMale"].intValue
                    if(g == 0){
                        self.gender.selectedSegmentIndex=1
                    }
                    print("")
                    
                }
                
                
        }
        
        
    }
    /*
 
 $id =    $app->request->post('id_user');
 $firstName = $app->request->post('firstName');
 $lastName = $app->request->post('lastName');
 $phoneNumber = $app->request->post('phoneNumber');
 $birthDate = $app->request->post('birthDate');
 $isMale = $app->request->post('isMale');
 */
 
 
    func update(idUser:String ,firstName:String,lastName:String,phoneNumber:String,birthDate:String,isMale:String)   {
        Alamofire.request(AppDelegate.serverUrl+"updateUserAccount", method: .post , parameters: ["id_user": idUser, "firstName":firstName,"lastName":lastName,"phoneNumber":phoneNumber,"birthDate":birthDate,"isMale":isMale  ])
            
            .responseJSON { response in
                print("Response String: \(response.result.value)")
                
                if let json = response.data {
                    let data = JSON(data: json)
                    
                    if(data["error"].bool)!{
                        return
                    }
                    
                    _ = self.navigationController?.popViewController(animated: true)
                    
                    //sucesss
                }
                
                
        }
        
        
    }
    
    

}
