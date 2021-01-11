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
//        let vc = UIImagePickerController()
//        vc.sourceType = .camera
//        vc.allowsEditing = true
//        vc.delegate = self
//        createClassificationsRequest(for: UIImage(named: "image")!)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
               print("No image found")
               return
           }

           // print out the image size as a test
           print(image.size)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
           dismiss(animated: true, completion: nil)
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
//         self.predictionLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
         return
       }
       let classifications = results as! [VNClassificationObservation]
       if classifications.isEmpty {
        print("Nothing recognized.")
//         self.predictionLabel.text = "Nothing recognized."
       } else {
         let topClassifications = classifications.prefix(2)
         let descriptions = topClassifications.map { classification in
           return String(format: "(%.2f) %@", classification.confidence, classification.identifier)
       }
        print(descriptions.joined(separator: " |"))
//       self.predictionLabel.text = descriptions.joined(separator: " |")
      }
    }
}
}
