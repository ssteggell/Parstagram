//
//  ProfileViewController.swift
//  Parstagram
//
//  Created by Spencer Steggell on 3/31/22.
//

import UIKit
import Parse
import AlamofireImage

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var feedCollectionView: UICollectionView!
    var imagePicker = UIImagePickerController()
    
    
    var profiles = [PFObject]()
    
    var currentUser = PFUser.current()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self

        let currentUser = PFUser.current()
        usernameLabel.text = currentUser?.username
        fetchData(currentUser!)

        // Do any additional setup after loading the view.
    }
    
    
    func fetchData(_ user: PFUser) {
        
        
        let query = PFQuery(className: "Profile")
        query.includeKeys(["user", "image"])
        
        query.findObjectsInBackground { (profiles, error) in
            if profiles != nil {
                self.profiles = profiles!
                print([profiles])
            }

        }
    }
    
    // TODO: Fetch logged in user and update logged in user info
    
    
    
// TODO: Add Profile photo to profile
    @IBAction func addProfilePhoto(_ sender: Any) {
        
        let alert = UIAlertController(title: "Choose or Upload Image For Profile Photo!", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { _ in
            self.openLibrary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
   
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func openCamera() {
        
        if (UIImagePickerController .isSourceTypeAvailable(.camera))
             {
                 imagePicker.sourceType = .camera
                 imagePicker.allowsEditing = true
                 self.present(imagePicker, animated: true, completion: nil)
             }
             else
             {
                 let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                 alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                 self.present(alert, animated: true, completion: nil)
             }
         }
    
    func openLibrary() {
        
        if (UIImagePickerController .isSourceTypeAvailable(.photoLibrary)) {
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageScaled(to: size)
        
        profileImageView.image = scaledImage
        
        savePhoto()
        
        dismiss(animated: true, completion: nil)
    }
    
    //TODO: Update collectionview with posts done by user
    
    @IBAction func onLogout(_ sender: Any) {
    }
    
    
    func savePhoto() {
        let post = PFObject(className: "Profile")
        
        post["user"] = PFUser.current()!
        let imageData = profileImageView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success {
                self.dismiss(animated: true, completion: nil)
                print("Saved!")
            } else {
                print("error!")
            }
        }
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
