//
//  ViewController.swift
//  Hotdog identifier
//
//  Created by Oskar Figiel on 11/01/2021.
//

import UIKit
import Vision
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    var imagePicker: UIImagePickerController!
    override func loadView() {
        let view = MainView()
        self.view = view
    }

    private var mainView: MainView {
        return view as! MainView
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.showWelcomeView()
        mainView.welcomeView.startButton.addTarget(self, action: #selector(takeNewPhoto), for: .touchUpInside)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(takeNewPhoto))
        mainView.backgroundImageView.isUserInteractionEnabled = true
        mainView.backgroundImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func takeNewPhoto() {
        mainView.hideViews()
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)

        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        mainView.showImageView(image: image)
        createClassificationsRequest(for: image)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) { }

    lazy var classificationRequest: VNCoreMLRequest = {
        DispatchQueue.main.async {
            self.mainView.loadingView.isHidden = false
            self.mainView.loadingView.rotate()
        }
        let model: HotDogClassifier = {
            do {
                let config = MLModelConfiguration()
                return try HotDogClassifier(configuration: config)
            } catch {
                print(error)
                fatalError("Couldn't create model")
            }
        }()
        do {
            let model = try VNCoreMLModel(for: model.model)
            let request = VNCoreMLRequest(model: model, completionHandler: {   [weak self] request, error in
                self?.processClassifications(for: request, error: error)
            })
            request.imageCropAndScaleOption = .centerCrop
            return request

        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()

    func createClassificationsRequest(for image: UIImage) {
        guard let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue)) else { return }
        guard let ciImage = CIImage(image: image)
        else {
            fatalError("Unable to create \(CIImage.self) from \(image).")
        }
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation)
            do {
                try handler.perform([self.classificationRequest])
            }catch {
                print("Failed to perform \n\(error.localizedDescription)")
            }
        }
    }

    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results
            else {
                print("Unable to classify image.\n\(error!.localizedDescription)")
                return
            }
            let classifications = results as! [VNClassificationObservation]
            if classifications.isEmpty {
                print("Nothing recognized.")
            } else {
                let topClassifications = classifications.prefix(2)
                let dict: [[String: Float]] = topClassifications.compactMap { classification in
                    return [classification.identifier : classification.confidence]
                }
                guard let result = dict[0].keys.first else {
                    return
                }
                self.mainView.loadingView.isHidden = true
                self.mainView.loadingView.stopRotating()
                if result == "Hotdog" {
                    self.mainView.showHotDogView()
                } else {
                    self.mainView.showNotHotdogView()
                }
            }
        }
    }
}
