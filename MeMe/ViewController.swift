//
//  ViewController.swift
//  MeMe
//
//  Created by Muthu on 11/19/20.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{
    @IBOutlet weak var bottomField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let textFieldDelegate = self
        topField.delegate = textFieldDelegate
        bottomField.delegate = textFieldDelegate
       
        topField.textAlignment = .center
        bottomField.textAlignment = .center
        // Do any additional setup after loading the view.
        let memeAttributes:[NSAttributedString.Key :Any] =
            [   NSAttributedString.Key.strokeColor : UIColor.black,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font : UIFont(name:"HelveticaNeue-CondensedBlack",size:30)!,
                NSAttributedString.Key.strokeWidth : 2.5
            ]
                  
        topField.defaultTextAttributes = memeAttributes
        bottomField.defaultTextAttributes = memeAttributes
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
           subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    @objc func keyboardWillShow(_ notification:Notification) {

        if self.view.frame.origin.y == 0{
        view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {

        let userInfo = notification.userInfo
        
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),name:UIResponder.keyboardWillShowNotification, object: nil)
       NotificationCenter.default.addObserver(self, selector: #selector(keyboardwillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func unsubscribeToKeyboardNotifications()
    {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
       // NotificationCenter.default.removeObserver(self,name: UIResponder.keyboardWillHideNotification,object: nil)
        
    }
    
    @objc func  keyboardwillHide(_ notification:Notification)
    {
        view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    @IBAction func cameraImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func libraryImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
         imageView.image = image 
        dismiss(animated: false, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: false, completion: nil)
    }
  

}

