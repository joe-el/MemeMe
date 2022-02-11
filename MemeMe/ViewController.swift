//
//  ViewController.swift
//  MemeMe
//
//  Created by Kenneth Gutierrez on 2/10/22.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    // Properties:
    let imagePicker = UIImagePickerController()
    let cameraController = UIImagePickerController()
    let bottomTextDelegate = BottomTextFieldDelegate()
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "Jurta", size: 60)!,
        NSAttributedString.Key.strokeWidth: -1.0
    ]
    
    // Outlet:
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var sharingIsCaring: UIBarButtonItem!
    @IBOutlet weak var cancelView: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Text settings:
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        bottomTextField.textAlignment = .center
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        
        // Set up delegates:
        topTextField.delegate = self
        bottomTextField.delegate = self.bottomTextDelegate
        
        // Set the share button as disabled:
        showShareButton(false)
        
        // Tap anywhere on the screen to dismiss the keyboard:
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Boolean check if camera is available on said device:
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Subscribe to notifications:
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Unsubscribe to notifications:
        unsubscribeFromKeyboardNotifications()
    }
    
    // Setting uo subscribtion for receiving information about the keyboard:
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    // Observer methods which does the automatic scrolling when keyboard appears and de-scrolling when keyboard disappears:
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing, view.frame.origin.y == 0  {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    // Getting the keyboard height from notification:
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        
        return keyboardSize.cgRectValue.height
    }
    
    // Text Field Delegates:
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if !textField.text!.isEmpty {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // Image View Delegates:
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[.originalImage] as? UIImage {
            imageView.image = chosenImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Action:
    @IBAction func caputureCameraImage(_ sender: Any) {
        // Set share button as enabled:
        showShareButton(true)
        
        // Set the delegate:
        cameraController.delegate = self
        cameraController.sourceType = .camera
        present(cameraController, animated: true, completion: nil)
    }

    @IBAction func pickAnImage(_ sender: Any) {
        // Set share button as enabled:
        showShareButton(true)
        
        // Set the delegate:
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMe(_ sender: Any) {
        let savedMemeImage: UIImage = generateMemedImage()
        
        let memeController = UIActivityViewController(activityItems: [savedMemeImage], applicationActivities: nil)
        
        self.present(memeController, animated: true,  completion: nil)
        
        memeController.completionWithItemsHandler =
        {
            memeController, success, items, error in
            if(success) {
                //save meme
                self.save()
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        // Set share button as disabled:
        showShareButton(false)
        
        if let topResults = topTextField.text {
            if topResults != "TOP" {
                topTextField.text = "TOP"
            }
        }
        if let bottomResults = bottomTextField.text {
            if bottomResults != "BOTTOM" {
                bottomTextField.text = "BOTTOM"
            }
        }
        // Discard any image in imageView:
        imageView.image = nil
    }
    
    /*
     * Combining image and text-grabing an image context and let it render the view hierarchy(image &
     * textfields in this case) into a UIImage object.
     */
    func generateMemedImage()-> UIImage {
        // Hide toolbar and navbar:
        hideNavAndToolBars(true)
        
        // Render view to an image:
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar:
        hideNavAndToolBars(false)
        
        return memedImage
    }
    
    // Initialize a Meme model object:
    func save() {
            // Create the meme object:
            _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: generateMemedImage())
    }
    
    // Enable or disable share button:
    func showShareButton(_ answer: Bool) {
        self.sharingIsCaring.isEnabled = answer
    }
    
    // Hides top and bottom bar:
    func hideNavAndToolBars(_ answer: Bool) {
        navBar.isHidden = answer
        toolBar.isHidden = answer
    }
}

