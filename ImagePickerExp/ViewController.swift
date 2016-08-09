//
//  ViewController.swift
//  ImagePickerExp
//
//  Created by Grigory Rudko on 7/27/16.
//  Copyright © 2016 Grigory Rudko. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    // struct for Meme object
    struct Meme {
        var textField1: String
        var textField2: String
        var image: UIImage
        var memedImage: UIImage
    }
    
    // need a variable for our struct in this VC
    var meme: Meme?
    var memeObject: Meme?
    
    
    
    
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    
    
    let topTextFieldDelegate = TopTextFieldDelegate()
    let bottomTextFieldDelegate = BottomTextFieldDelegate()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // Subscribe to Key Board Notifications
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // why do we need to unsubscribe from notifications???
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    // lifting up UIView
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y = 0
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    // moving the UIView back
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.enabled = false

        self.topTextField.delegate = self.topTextFieldDelegate
        self.bottomTextField.delegate = self.bottomTextFieldDelegate
        
        let memeTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 50)!,
            NSStrokeWidthAttributeName : -3.0
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        //        imagePickerView.backgroundColor = UIColor.blackColor()
        topTextField.text = "TOP"
        topTextField.textAlignment = .Center
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .Center
        

    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }
    
    
    
    @IBAction func pickAnImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        shareButton.enabled = true

    }
    
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
        shareButton.enabled = true
        
    }
    
    
    @IBAction func shareTheMeme(sender: AnyObject) {
        
    }
    
    //    Combining image and text
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navigationController?.navigationBarHidden = true
        navigationController?.setToolbarHidden(true, animated: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar, again
        navigationController?.navigationBarHidden = false
        navigationController?.setToolbarHidden(false, animated: false)
        
        return memedImage
        
    }
    
    
    
    
    
    
    //    Initializing a Meme object
    func saveMeme() -> Meme {
        memeObject = Meme(textField1: topTextField.text!, textField2: bottomTextField.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
        
        return memeObject!
        
        
        
        
    }
    
    
    
    
    
    
    
}















