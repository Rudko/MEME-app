//
//  BottomTextFieldDelegate.swift
//  ImagePickerExp
//
//  Created by Grigory Rudko on 8/2/16.
//  Copyright © 2016 Grigory Rudko. All rights reserved.
//

import Foundation
import UIKit

class BottomTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return true
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        view.frame.origin.y = 0
        
        return true
    }
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField.text == "BOTTOM" {
            textField.text = ""
        }
}
    
}























