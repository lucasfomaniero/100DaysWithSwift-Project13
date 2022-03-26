//
//  ViewController.swift
//  Project13
//
//  Created by Lucas Maniero on 06/03/22.
//

import UIKit
import CoreImage




class ViewController: UIViewController {
    var currentImage: UIImage! {
        didSet {
            photoFilter.currentImage = currentImage
        }
    }
    var photoFilter: PhotoFilter = PhotoFilter(.sepia)

    let containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .secondarySystemBackground
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let intensityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .natural
        label.text = "Intensity"
        return label
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(intensityChanged), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let changeFilterButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.tintColor = .tintColor
        sb.setTitle("Change filter", for: .normal)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.addTarget(self, action: #selector(changeFilter), for: .touchUpInside)
        return sb
    }()
    
    let saveButton: UIButton = {
        let sb = UIButton(type: .system)
        sb.tintColor = .tintColor
        sb.setTitle("Save", for: .normal)
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.addTarget(self, action: #selector(save), for: .touchUpInside)
        return sb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Instafilter"
        layoutConstraints()
        setupButtons()
    }
    
    
    @objc func save() {
        guard let image = imageView.image else { return }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    @objc func changeFilter() {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        
        for filter in PhotoFilter.FilterType.allCases {
            ac.addAction(.init(title: filter.name, style: .default, handler: setFilter))
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    func setFilter(action: UIAlertAction) {
        guard let filterName = action.title else { return }
        photoFilter.applyFilter(with: filterName)
        applyProcessing()
    }
    
    func applyProcessing() {
        self.imageView.image = photoFilter.processedImage
    }
    @objc func intensityChanged() {
        photoFilter.intensity = Double(slider.value)
        applyProcessing()
    }
    
    func setupButtons() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
    }
    
    func layoutConstraints() {
        view.addSubviews(containerView, intensityLabel, slider, changeFilterButton, saveButton)
        containerView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7),
            
            imageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            
            intensityLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            intensityLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 8),
            intensityLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            intensityLabel.heightAnchor.constraint(equalToConstant: 16),
            
            slider.leadingAnchor.constraint(equalTo: intensityLabel.trailingAnchor),
            slider.topAnchor.constraint(equalTo: intensityLabel.topAnchor),
            slider.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            slider.heightAnchor.constraint(equalTo: intensityLabel.heightAnchor),
            
            changeFilterButton.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            changeFilterButton.topAnchor.constraint(equalTo: intensityLabel.bottomAnchor, constant: 8),
            changeFilterButton.heightAnchor.constraint(equalToConstant: 32),
            
            saveButton.topAnchor.constraint(equalTo: changeFilterButton.topAnchor),
            saveButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            saveButton.heightAnchor.constraint(equalTo: changeFilterButton.heightAnchor),
            
        ])
        
       
    }

}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        photoFilter.currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
}
