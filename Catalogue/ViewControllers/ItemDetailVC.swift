//
//  ItemDetailVC.swift
//  Catalogue
//
//  Created by Jonathon Bauer on 2019-10-18.
//  Copyright © 2019 Jonathon Bauer. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailVC: UIViewController {
    
    // MARK: Properties
    var item: Item?
    var db: DBHelper!
    var categories = [Category]()
    var selectedCategory: Category?
    var imageData: Data?
    var picker: UIPickerView?
    var isInEditMode = false
    var previousVC: UIViewController?
    var soldout = false
    var imagePicker: UIImagePickerController?
    var numberFormatter = Formatter(minDecimalPlaces: 2, maxDecimalPlaces: 2)
    
    
    
    
    // MARK: Outlets
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var details: UITextView!
    @IBOutlet weak var stockButton: UIButton!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    
    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register a tap recognizer to dismiss the keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // Register a tap recognizer to detect when the user taps on the imageView
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        self.imageView.addGestureRecognizer(imageTap)
        
        // Set interactivity to false by default
        self.imageView.isUserInteractionEnabled = false
        
        // Create an ImagePicker and assign its delegate
        self.imagePicker = UIImagePickerController()
        self.imagePicker?.delegate = self
        
        // Set the text fields delegates to this view controller
        self.name.delegate = self
        self.price.delegate = self
        self.details.delegate = self
        
        // Customize the buttons
        stockButton.layer.cornerRadius = 10
        
        // Customize the text fields
        self.details.layer.cornerRadius = 5
        self.details.layer.borderWidth = 0.5
        self.details.layer.borderColor = UIColor.lightGray.cgColor
        self.details.clipsToBounds = true
        
        
        
        // Set the title
        self.navBar.topItem?.title = "New Item"
        
        // Create and customise the picker for selecting the category
        picker = UIPickerView()
        
        // Add a done button to the pickerview
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(pickerSelected))

        toolBar.setItems([spacer, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        
        // Set the inputView of the Category TextField to the picker
        category.inputView = picker
        category.inputAccessoryView = toolBar
        
        // Assign the delegate and datasource of the picker to this class
        picker?.dataSource = self
        picker?.delegate = self
        
        
        
        // MARK: Populate Item Information

        if let item = item {
            // Disable edit mode if this an existing item
            setEditMode(enabled: false)
            
            // Set the Title
            self.navBar.topItem?.title = item.name
            
            self.name.text = item.name
            self.price.text = "$\(self.numberFormatter.format.string(from: NSNumber(value: item.price)) ?? "$0.00")"
            self.details.text = item.details
            self.category.text = item.category?.name
            selectedCategory = item.category
            self.soldout = item.soldOut
            if item.soldOut {
                self.stockButton.setTitle("Sold Out", for: .normal)
            } else {
                self.stockButton.setTitle("In Stock", for: .normal)
            }
            
            
            if let data = item.image {
                self.imageView.image = UIImage(data: data)
            }
            
            
        } else {
            // If this is a new item
            setEditMode(enabled: true)
            self.navBar.topItem?.leftBarButtonItem = nil
            self.navBar.topItem?.rightBarButtonItem?.title = "Save Item"
            
        }
        
    }
    
    // MARK: View Will Appear
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Get the database if it is nil
        if db == nil {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            db = appDelegate.dbHelper
        }
        
        categories = db.getAllCategories()
    }
    
    // MARK: - Custom Functions
    
    
    
    // MARK: Edit Item
    
    @IBAction func editItem(_ sender: Any) {
        if(isInEditMode) {
            let success = saveItem()
            if (success) {
                setEditMode(enabled: false)
            }
        } else {
            setEditMode(enabled: true)
        }
    }
    
    
    // MARK: Delete Item
    @IBAction func deleteItem(_ sender: Any) {
        
        guard let item = item else { return }
        
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: .alert)
        
        let delete = UIAlertAction(title: "Delete Item", style: .destructive, handler: { _ in
            self.db.deleteItem(item: item)
            
            if let previousVC = self.previousVC {
                previousVC.viewWillAppear(true)
            }
            
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(delete)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: Toggle Sold Out
    @IBAction func toggleSoldOut(_ sender: Any) {
        if soldout {
            soldout = false
            stockButton.setTitle("In Stock", for: .normal)
            
        } else {
            soldout = true
            stockButton.setTitle("Sold Out", for: .normal)
        }
    }
    
    
    // MARK: Dismiss Keyboard
    
    // Create an action to dismiss the keyboard
    @objc func dismissKeyboard() {
        print("Dismissing keyboard")
        view.endEditing(true)
    }
    
    // MARK: Picker Selected
    @objc func pickerSelected(){
        
        if let row = picker?.selectedRow(inComponent: 0) {
            category.text = categories[row].name
            selectedCategory = categories[row]
            category.resignFirstResponder()
        }
        
        
    }
    
    // MARK: Set Edit Mode
    func setEditMode(enabled: Bool) {
        if(enabled) {
            self.editButton.title = "Done"
            self.navBar.topItem?.leftBarButtonItem = self.deleteButton
            self.stockButton.isEnabled = true
            self.name.isEnabled = true
            self.price.isEnabled = true
            self.category.isEnabled = true
            self.details.isEditable = true
            self.imageView.isUserInteractionEnabled = true
            self.isInEditMode = true
        } else {
            self.editButton.title = "Edit"
            self.navBar.topItem?.leftBarButtonItem = nil
            self.stockButton.isEnabled = false
            self.name.isEnabled = false
            self.price.isEnabled = false
            self.category.isEnabled = false
            self.details.isEditable = false
            self.imageView.isUserInteractionEnabled = false
            self.isInEditMode = false
            self.dismissKeyboard()
        }
    }
    
    // MARK: Image Tapped
    
    @objc func imageTapped() {
        
        // Create the alert controller
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoButton = UIAlertAction(title: "Take Photo", style: .default) { _ in
            // Open the camera
            self.imagePicker?.sourceType = .camera
            self.present(self.imagePicker!, animated: true, completion: nil)
        }
        
        let selectImageButton = UIAlertAction(title: "Select Photo", style: .default) { _ in
            // Open the photo library
            self.imagePicker?.sourceType = .savedPhotosAlbum
            self.present(self.imagePicker!, animated: true, completion: nil)
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(takePhotoButton)
        alertController.addAction(selectImageButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    // MARK: Save Item

    
    func saveItem() -> Bool {
        print("Save button pressed")
        // Check that there is valid input
        guard
            let nameInput = self.name.text,
            nameInput.count > 0,
            let priceInput = (self.price.text as NSString?)?.doubleValue,
            let detailsInput = self.details.text,
            detailsInput.count > 0,
            let categoryInput = self.selectedCategory
            else {
                print("Invalid input")
                return false
        }
        
        
        if let selectedItem = item {
            selectedItem.name = nameInput
            selectedItem.price = priceInput
            selectedItem.details = detailsInput
            selectedItem.category = categoryInput
            selectedItem.soldOut = soldout
            
            if let data = self.imageData {
                selectedItem.image = data
            }
            
            db.save()
            
            if let previousVC = self.previousVC {
                previousVC.viewWillAppear(true)
            }
            self.navBar.topItem?.title = nameInput
            
            return true
            //            self.dismiss(animated: true, completion: nil)
            
        } else {
            let success = db.addItem(name: nameInput, image: imageData, price: priceInput, details: detailsInput, soldOut: soldout, category: selectedCategory, completion: {
                print("Successfully added item!")
                
                if let previousVC = self.previousVC {
                    previousVC.viewWillAppear(true)
                }
                self.dismiss(animated: true, completion: nil)
                
            })
            
            if(!success) {
                print("Could not add item")
                return false
            }
            return true
        }
    }
    
}

// MARK: - Extensions



// MARK: Text Field Extensions

extension ItemDetailVC:UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

extension ItemDetailVC:UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.resignFirstResponder()
    }
}


// MARK: PickerView Extensions
extension ItemDetailVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
}

extension ItemDetailVC: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].name

    }
    
}

// MARK: ImagePicker Extensions

extension ItemDetailVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        
        if let image = cropImage(image: selectedImage) {
            self.imageView.image = cropImage(image: image)
            self.imageData = image.jpegData(compressionQuality: 1.0)
        } else {
            print("Something went wrong cropping and saving the image")
        }
        
    }
    
    // Function used to crop the photo after its taken
    
    func cropImage(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        
        guard let cgImage = image.cgImage, let filter = CIFilter(name: "CICrop")
            else { return nil }
        
        let imageOrientation = image.imageOrientation
        
        
        let size = CGFloat(min(cgImage.width, cgImage.height))
        let center = CGPoint(x: cgImage.width / 2, y: cgImage.height / 2)
        let origin = CGPoint(x: center.x - size / 2, y: center.y - size / 2)
        let cropRect = CGRect(origin: origin, size: CGSize(width: size, height: size))
        
        let sourceImage = CIImage(cgImage: cgImage)
        filter.setValue(sourceImage, forKey: kCIInputImageKey)
        filter.setValue(CIVector(cgRect: cropRect), forKey: "inputRectangle")
        
        guard let outputImage = filter.outputImage,
            let cgImageOut = context.createCGImage(outputImage, from: outputImage.extent)
            else { return nil }
        
        return UIImage(cgImage: cgImageOut, scale: 1, orientation: imageOrientation)
    }
    
    
    
    
}
