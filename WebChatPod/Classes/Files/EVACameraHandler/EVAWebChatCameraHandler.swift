//
//  EVAWebChatCameraHandler.swift
//  WebChat
//
//  Created by Raghavendra on 07/05/24.
//

import UIKit
import Foundation

protocol EVAWebChatCameraHandlerDelegate {
    
    func capturedImageSuccess(image:UIImage)
    func capturedImageFail()
}

class EVAWebChatCameraHandler: NSObject,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate:EVAWebChatCameraHandlerDelegate?                   // Instance of EVAWebChatCameraHandlerDelegate protocol.
    public static let sharedInstance = EVAWebChatCameraHandler()    // Shared instance of EVAWebChatCameraHandler.
    
    //MARK: imagePickerController(_:didFinishPickingMediaWithInfo:)
    /// Tells the delegate that the user picked a still image or movie.
    /// - Parameters:
    ///   - picker: The controller object managing the image picker interface.
    ///   - info: A dictionary containing the original image and the edited image, if an image was picked; or a filesystem URL for the movie, if a movie was picked. The dictionary also contains any relevant editing information. The keys for this dictionary are listed in UIImagePickerController.InfoKey.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let normalizedImage = fixOrientation(img: pickedImage) {
            if(delegate != nil) {
                delegate?.capturedImageSuccess(image: normalizedImage)
            }
        } else {
            if(delegate != nil) {
                delegate?.capturedImageFail()
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }

    //MARK: imagePickerControllerDidCancel(_:)
    /// Tells the delegate that the user canceled the pick operation.
    /// - Parameter picker: The controller object managing the image picker interface.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        if(delegate != nil) {
            delegate?.capturedImageFail()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: launchCameraUI
    /// Launch the camera interface for capturing an image.
    /// - Parameter viewcontroller: UIViewController
    func launchCameraUI(viewcontroller:UIViewController) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            // Set the source type of the image picker to the camera.
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            // Set whether the image picker allows editing of captured images.
            imagePicker.allowsEditing = false
            // Present the image picker modally on the provided view controller.
            viewcontroller.present(imagePicker, animated: true, completion: nil)
        } else {
            if(delegate != nil) {
                delegate?.capturedImageFail()
            }
        }
                
    }
    
    //MARK: fixOrientation
    /// FIx the orientation of an image.
    /// - Parameter img: UIImage
    /// - Returns: UIImage
    func fixOrientation(img:UIImage) -> UIImage? {

        // Check if the image orientation is already upright.
        if (img.imageOrientation == UIImage.Orientation.up) {
            return img;
        }

        // If the image orientation is not upright, fix its orientation.
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale);
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in:rect)

        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return normalizedImage;

    }
    
}

