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
        mainView.welcomeView.startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }

    @objc func startButtonClicked() {
        mainView.hideWelcomeView()
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        mainView.showImageView(image: image)
        
        createClassificationsRequest(for: image)
        imagePicker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }

    lazy var classificationRequest: VNCoreMLRequest = {
        let model: HotDogClassifier = {
            do {
                let config = MLModelConfiguration()
                return try HotDogClassifier(configuration: config)
            } catch {
                print(error)
                fatalError("Couldn't create SleepCalculator")
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
        //        predictionLabel.text = "Classifying..."
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
                if result == "Hotdog" {
                    self.mainView.showHotDogView()
                } else {
                    self.mainView.showNotHotdogView()
                }
                print(result)
            }
        }
    }
}
