//
//  HomeViewController.swift
//  Fontagram
//
//  Created by Ryan David on 2/28/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit


var pickedImage: UIImage?

class HomeViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate
{

    @IBOutlet weak var bkgImage: UIImageView!
    @IBOutlet weak var buttonsView: UIView!

override func prefersStatusBarHidden() -> Bool
{
    return true
}
func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool)
{
    UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
}
    
override func viewDidLoad()
{
        super.viewDidLoad()
}
  
@IBAction func cameraButt(sender: AnyObject) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}
    
@IBAction func libraryButt(sender: AnyObject) {
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
    {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imagePicker.allowsEditing = true
        presentViewController(imagePicker, animated: true, completion: nil)
    }
}
    
func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?)
{
        pickedImage = image
        dismissViewControllerAnimated(true) { () -> Void in
            let ieVC = self.storyboard?.instantiateViewControllerWithIdentifier("ImageEditorViewController") as! ImageEditorViewController
            self.navigationController?.pushViewController(ieVC, animated: true)
    }
}

override func didReceiveMemoryWarning()
{
        super.didReceiveMemoryWarning()
    }
}

