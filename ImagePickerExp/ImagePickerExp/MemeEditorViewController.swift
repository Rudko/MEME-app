//
//  MemeEditorViewController.swift
//  ImagePickerExp
//
//  Created by Grigory Rudko on 7/27/16.
//  Copyright © 2016 Grigory Rudko. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    
    
    // need a variable for our struct in this VC
    var meme: Meme?
    var memeObject: Meme?
    
    
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var libraryButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    
    
    let topTextFieldDelegate = TopTextFieldDelegate()
    let bottomTextFieldDelegate = BottomTextFieldDelegate()
    
    let imagePicker = UIImagePickerController()
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }
    
    
    
    // Subscribe to Keyboard Notifications
    func subscribeToKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:))    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:))    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    // Unsubscribing from notifications
    func unsubscribeFromKeyboardNotifications() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillHideNotification, object: nil)
    }
    
    // Lifting up UIView
    func keyboardWillShow(notification: NSNotification) {
        
        if bottomTextField.isFirstResponder() {
            
            view.frame.origin.y = getKeyboardHeight(notification) * (-1)
            
        }
    }
    
    
    
    // Moving the UIView back
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    
    // Getting keyboard height
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        shareButton.enabled = false
        
        
        //        Textfields attributes
        func configureTextFields(textField: UITextField) {
            
            let memeTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSStrokeColorAttributeName : UIColor.blackColor(),
                NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                NSStrokeWidthAttributeName : -3.0
            ]
            
            textField.defaultTextAttributes = memeTextAttributes
            textField.textAlignment = .Center
        }
        
        
        configureTextFields(topTextField)
        configureTextFields(bottomTextField)
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        // Note to a reviewer: I realized that I can merge these two delegates too. Is it a good idea?
        topTextField.delegate = topTextFieldDelegate
        bottomTextField.delegate = bottomTextFieldDelegate
        
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    
    //    Getting an image
    func pickAnImageFromSource(source: UIImagePickerControllerSourceType) {
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
        shareButton.enabled = true
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        pickAnImageFromSource(.PhotoLibrary)
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
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
        pickAnImageFromSource(.Camera)
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        
    }
    
    
    
    func configurePicker(type: UIImagePickerControllerSourceType) -> UIImagePickerController{
        
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = type
        imagePicker.delegate = self
        
        return imagePicker
        
    }
    
    func presentPickerController(picker: UIImagePickerController){
        presentViewController(picker, animated: true, completion: nil)
    }
    
    
    func presentVC(controller: UIActivityViewController){
        presentViewController(controller, animated: true, completion: nil)
    }
    
    
    
    // Create a meme object and save it to to the memes array
    func saveMeme() /* ->  Meme */ {
        
        // Update the meme
        memeObject = Meme(textField1: topTextField.text!, textField2: bottomTextField.text!, image: imagePickerView.image!, memedImage: generateMemedImage())
        
        // заменяют ли эти три строки последующую откомментированную?
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme!)
        
        // Add it to the memes array on the Application Delegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme!)

        //return memeObject!
        
    }
    
    //    Combining image and text
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navigationBar.hidden = true
        toolBar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawViewHierarchyInRect(self.view.frame,
                                     afterScreenUpdates: true)
        let memedImage : UIImage =
            UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar, again
        navigationBar.hidden = false
        toolBar.hidden = false
        
        return memedImage
        
    }
    
    
    
    @IBAction func shareTheMeme(sender: AnyObject) {
        
        // Instantiate activity view controller
        let activityViewController = UIActivityViewController.init(activityItems: [generateMemedImage()], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = sender as? UIView
        
        
        presentVC(activityViewController)
        
        
        // Save it in the completionWithItemsHandler closure
        activityViewController.completionWithItemsHandler = {
            (activityType, completed:Bool, returnedItems:[AnyObject]?, error: NSError?) in
            
            if completed {
                self.saveMeme()
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
    }
    
    
    
}















