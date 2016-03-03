//
//  ImageEditorViewController.swift
//  Fontagram
//
//  Created by Ryan David on 2/28/16.
//  Copyright © 2016 Ryan David. All rights reserved.
//

import UIKit
import Social

class ImageEditorViewController: UIViewController,
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate,
UIDocumentInteractionControllerDelegate,
UIAlertViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate

{
    @IBOutlet weak var toolsView: UIView!
    @IBOutlet weak var fontsTableView: UITableView!
    @IBOutlet weak var colorsView: UIView!
    @IBOutlet weak var rgbImage: UIImageView!
    @IBOutlet weak var cropView: UIView!
    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var txtView: UITextView!
    @IBOutlet weak var openToolsOutlet: UIButton!
    @IBOutlet weak var alignOutlet: UIButton!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var imageViewBottom: UIImageView!
    
    var fontSize:CGFloat = 25.0
    var fontName = ""
    var fontsTBisOpen = Bool()
    var colorsIsOpen = Bool()
    var alignment = 0
    var firstText = Bool()
    var docIntController = UIDocumentInteractionController()
    let socialController = SLComposeViewController()
    var imageToBeShared: UIImage?
    
override func prefersStatusBarHidden() -> Bool {
    return true
}
    
override func viewDidLoad() {
        super.viewDidLoad()

    toolsView.frame.origin.x = -toolsView.frame.size.width
    fontsTableView.frame.origin.x = -fontsTableView.frame.size.width
    colorsView.frame.origin.x = -colorsView.frame.size.width
    shareView.frame.origin.x = view.frame.size.width
    colorsView.layer.borderColor = UIColor.blackColor().CGColor
    colorsView.layer.borderWidth = 1
    colorsView.layer.cornerRadius = 10
    
    fontsTBisOpen = false
    colorsIsOpen = false
    
    cropView.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.width)
    imagePicked.image = pickedImage!
    
    fontName = "\(fontsArray[0])"
    fontSize = 25.0
    firstText = false
    alignment = 0
    txtView.textColor = UIColor.whiteColor()
    
    let toolbar = UIView(frame: CGRectMake(0, view.frame.size.height+44, view.frame.size.width, 44))
    toolbar.backgroundColor = UIColor.clearColor()
    let doneButt = UIButton(frame: CGRectMake(toolbar.frame.size.width - 60, 0, 44, 44))
    doneButt.setBackgroundImage(UIImage(named: "dismissKeybButt"), forState: UIControlState.Normal)
    doneButt.addTarget(self, action: "dismissKeyboard", forControlEvents: UIControlEvents.TouchUpInside)
    toolbar.addSubview(doneButt)
    txtView.inputAccessoryView = toolbar
    txtView.delegate = self
}

func dismissKeyboard() {
txtView.resignFirstResponder()
}

@IBAction func openToolsButt(sender: AnyObject) {
    showToolsView()
    openToolsOutlet.hidden = true
        
}
    
@IBAction func openFontsTBbutt(sender: AnyObject) {
    fontsTBisOpen = !fontsTBisOpen
    
    if fontsTBisOpen {
        showFontsTB()
        hideColors(); colorsIsOpen = false
    } else {
        hidefontsTB()
    }
}

@IBAction func colorButt(sender: AnyObject) {
    colorsIsOpen = !colorsIsOpen
        
    if colorsIsOpen {
        showColors()
        hidefontsTB(); fontsTBisOpen = false
    } else {
        hideColors()
    }
}
    
@IBAction func hideToolsbutt(sender: AnyObject) {
    hideToolsView()
    hidefontsTB()
    hideColors()
    
    fontsTBisOpen = false
    colorsIsOpen = false
}
   
@IBAction func txtSizeButtons(sender: AnyObject) {
    let butt = sender as! UIButton
    
    switch butt.tag {
    case 1: fontSize++;  break
    case 2: fontSize--; break
    default:break  }
    
    txtView.font = UIFont(name: fontName, size: fontSize)
    resetTxtViewFrame()
}
    
@IBAction func alignmentButt(sender: AnyObject) {
    alignment++
    if alignment > 2 { alignment = 0 }
    
    switch alignment {
    case 0:
        txtView.textAlignment = NSTextAlignment.Center
        alignOutlet.setBackgroundImage(UIImage(named: "alignCenter"), forState: UIControlState.Normal)
        break
    case 1:
        txtView.textAlignment = NSTextAlignment.Left
        alignOutlet.setBackgroundImage(UIImage(named: "alignLeft"), forState: UIControlState.Normal)
        break
    case 2:
        txtView.textAlignment = NSTextAlignment.Right
        alignOutlet.setBackgroundImage(UIImage(named: "alignRight"), forState: UIControlState.Normal)
        break
        
    default:break }
}
 
    var pickedColor = UIColor()
    
override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    let touch = touches.first
    let touchLocation = touch!.locationInView(rgbImage)
    
    if CGRectContainsPoint(rgbImage.frame, touchLocation) {
        pickedColor = getPixelColorAtPoint(touchLocation)
        txtView.textColor = pickedColor
    }
    
}
    
override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
    let touch = touches.first
    let touchLocation = touch!.locationInView(rgbImage)

    if CGRectContainsPoint(rgbImage.frame, touchLocation) {
        pickedColor = getPixelColorAtPoint(touchLocation)
        txtView.textColor = pickedColor
    }
    
}
    
func getPixelColorAtPoint(point:CGPoint) -> UIColor {
    let pixel = UnsafeMutablePointer<CUnsignedChar>.alloc(4)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
    let context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, bitmapInfo.rawValue)
    CGContextTranslateCTM(context, -point.x, -point.y)
    rgbImage.layer.renderInContext(context!)
    let color:UIColor = UIColor(red: CGFloat(pixel[0])/255.0, green: CGFloat(pixel[1])/255.0, blue: CGFloat(pixel[2])/255.0, alpha: CGFloat(pixel[3])/255.0)
    pixel.dealloc(4)
        
return color
}
   
@IBAction func newImageButt(sender: AnyObject) {
    let alert = UIAlertView(title: "New Image",
        message: "Select Source",
        delegate: self,
        cancelButtonTitle: "Cancel",
        otherButtonTitles: "Camera", "Photo Library")
    alert.show()
}

func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
    if alertView.buttonTitleAtIndex(buttonIndex) == "Camera" {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera;
            imagePicker.allowsEditing = true
            presentViewController(imagePicker, animated: true, completion: nil)
        }

    } else if alertView.buttonTitleAtIndex(buttonIndex) == "Photo Library" {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary)
        {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            imagePicker.allowsEditing = true
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
}

func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicked.image = image
        dismissViewControllerAnimated(true, completion: nil)
}
  
// MARK: - Fonts table
func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
}
    
func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return fontsArray.count
}
    
func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("FontCell", forIndexPath: indexPath) as! FontCell
    
    cell.fontLabel.text = "\(fontsArray[indexPath.row])"
    cell.fontLabel.font = UIFont(name: "\(fontsArray[indexPath.row])", size: 20)
    
return cell
}
    
func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 70
}

func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let cell = tableView.cellForRowAtIndexPath(indexPath) as! FontCell
    fontName = cell.fontLabel.text! 
    
    txtView.font = UIFont(name: fontName, size: fontSize)
    resetTxtViewFrame()
}
    
func textViewDidChange(textView: UITextView) {
    resetTxtViewFrame()
}
 
func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    hideToolsView()
    hidefontsTB()
    hideColors()
    fontsTBisOpen = false 
    colorsIsOpen = false
    
    if !firstText { txtView.text = "" }
    firstText = true
    
return true
}
    
func resetTxtViewFrame() {
    let fixedWidth = CGFloat(txtView.frame.size.width)
    let maxFloat = CGFloat(MAXFLOAT)
    let newSize:CGSize = txtView.sizeThatFits(CGSizeMake(fixedWidth, maxFloat))
    var newFrame:CGRect = txtView.frame
    newFrame.size = CGSizeMake(fmax(newSize.width, fixedWidth), newSize.height)
    txtView.frame = newFrame
}
    
@IBAction func moveTxtView(sender: UIPanGestureRecognizer) {
    let translation: CGPoint =  sender.translationInView(self.view)
    sender.view?.center = CGPointMake(sender.view!.center.x +  translation.x, sender.view!.center.y + translation.y)
    sender.setTranslation(CGPointMake(0, 0), inView: self.view)
}
    
@IBAction func shareButt(sender: AnyObject) {
    renderImageWithText()
    openShareMenu()
}
    
func renderImageWithText() {
    let rect = cropView.bounds
    UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
    cropView.drawViewHierarchyInRect(cropView.bounds, afterScreenUpdates: false)
    imageToBeShared = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
}
 
func openShareMenu() {
    hideColors(); hidefontsTB(); hideToolsView();
    fontsTBisOpen = false
    colorsIsOpen = false
    
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.shareView.frame.origin.x = self.view.frame.size.width/2 - self.shareView.frame.size.width/2
    }, completion: { (finished: Bool) in })
}
   
@IBAction func closeSVbutt(sender: AnyObject) {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.shareView.frame.origin.x = self.view.frame.size.width
    }, completion: { (finished: Bool) in })
}

@IBAction func saveToPLbutt(sender: AnyObject) {
    UIImageWriteToSavedPhotosAlbum(imageToBeShared!, nil, nil, nil)
    
    let alert = UIAlertView(title: APP_NAME,
        message: "Image saved to Photo Library!",
        delegate: nil,
        cancelButtonTitle: "OK")
    alert.show()
}
    
@IBAction func twitterButt(sender: AnyObject) {
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
        let twSheet = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        twSheet.addImage(imageToBeShared)
        self.presentViewController(twSheet, animated: true, completion: nil)
    } else {
        let alert: UIAlertView = UIAlertView(title: "Twitter",
            message: "Please login to your Twitter account in Settings",
            delegate: nil,
            cancelButtonTitle: "OK")
        alert.show()
    }
    
    socialController.completionHandler = { result -> Void in
        var output = ""
        switch result {
        case SLComposeViewControllerResult.Cancelled: output = "Sharing cancelled"; break
        case SLComposeViewControllerResult.Done: output = "Your image is on Twitter!"; break
        }
        
        let alert = UIAlertView(title: "Twitter",
            message: output,
            delegate: nil,
            cancelButtonTitle: "OK")
        alert.show()
    }
}
    
@IBAction func facebookButt(sender: AnyObject) {
    if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
        let fbSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        fbSheet.addImage(imageToBeShared)
        presentViewController(fbSheet, animated: true, completion: nil)
    } else {
        let alert = UIAlertView(title: "Facebook",
            message: "Please login to your Facebook account in Settings",
            delegate: nil,
            cancelButtonTitle: "OK")
        alert.show()
    }
    
    socialController.completionHandler = { result -> Void in
        var output = ""
        switch result {
        case SLComposeViewControllerResult.Cancelled: output = "Sharing cancelled"; break
        case SLComposeViewControllerResult.Done: output = "Your image is on Facebook!"; break
        }
        let alert = UIAlertView(title: "Facebook",
            message: output,
            delegate: nil,
            cancelButtonTitle: "OK")
        alert.show()
    }
    
}

@IBAction func instagramButt(sender: AnyObject) {
    let instagramURL = NSURL(string: "instagram://app")!
    if UIApplication.sharedApplication().canOpenURL(instagramURL) {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let savedImagePath:String = paths.stringByAppendingString("/image.igo")
        let imageData: NSData = UIImageJPEGRepresentation(imageToBeShared!, 1.0)!
        imageData.writeToFile(savedImagePath, atomically: false)
      
        let getImagePath = paths.stringByAppendingString("/image.igo")
        let fileURL: NSURL = NSURL.fileURLWithPath(getImagePath)
        
        docIntController = UIDocumentInteractionController(URL: fileURL)
        docIntController.UTI = "com.instagram.exclusivegram"
        docIntController.delegate = self
        docIntController.presentOpenInMenuFromRect(CGRectZero, inView: self.view, animated: true)
        
    } else {
        let alert:UIAlertView = UIAlertView(title: APP_NAME,
            message: "Instagram not found, please download it on the App Store",
            delegate: nil,
            cancelButtonTitle: "OK")
        alert.show()
    }
    
}
    
@IBAction func otherAppsButt(sender: AnyObject) {
    
    // MARK: - Save
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    let savedImagePath:String = paths.stringByAppendingString("/image.jpg")
    let imageData: NSData = UIImageJPEGRepresentation(imageToBeShared!, 0.8)!
    imageData.writeToFile(savedImagePath, atomically: false)
    
    let getImagePath = paths.stringByAppendingString("/image.jpg")
    let fileURL: NSURL = NSURL.fileURLWithPath(getImagePath)
    
    // MARK: - Sharing
    docIntController.delegate = self
    docIntController = UIDocumentInteractionController(URL: fileURL)
    docIntController.presentOpenInMenuFromRect(CGRectZero, inView: self.view, animated: true)
}
 
func showToolsView() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.toolsView.frame.origin.x = 0
    }, completion: { (finished: Bool) in })
}
    
func hideToolsView() {
    openToolsOutlet.hidden = false
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.toolsView.frame.origin.x = -self.toolsView.frame.size.width
    }, completion: { (finished: Bool) in })
}
 
func showFontsTB() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.fontsTableView.frame.origin.x = self.toolsView.frame.size.width
        }, completion: { (finished: Bool) in })
}
    
func hidefontsTB() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.fontsTableView.frame.origin.x = -self.fontsTableView.frame.size.width
        }, completion: { (finished: Bool) in })
}
    
func showColors() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.colorsView.frame.origin.x = self.toolsView.frame.size.width
    }, completion: { (finished: Bool) in })
}
    
func hideColors() {
    UIView.animateWithDuration(0.1, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
        self.colorsView.frame.origin.x = -self.colorsView.frame.size.width
    }, completion: { (finished: Bool) in })
}

override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
