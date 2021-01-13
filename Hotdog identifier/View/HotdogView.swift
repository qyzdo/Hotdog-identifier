//
//  HotdogView.swift
//  Hotdog identifier
//
//  Created by Oskar Figiel on 13/01/2021.
//

import UIKit

final class HotDogView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(containerView)
        containerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true

        containerView.addSubview(label)
        label.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        label.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true

        self.addSubview(circleView)
        circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        circleView.centerYAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 25).isActive = true
        circleView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        circleView.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: circleView.leftAnchor, constant: 25).isActive = true
        imageView.rightAnchor.constraint(equalTo: circleView.rightAnchor, constant: -25).isActive = true
        imageView.bottomAnchor.constraint(equalTo: circleView.bottomAnchor, constant: -25).isActive = true
        imageView.topAnchor.constraint(equalTo: circleView.topAnchor, constant: 25).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 61/255, green: 200/255, blue: 53/255, alpha: 1.0)
        return view
    }()

    private var circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 61/255, green: 200/255, blue: 53/255, alpha: 1.0)
        view.layer.cornerRadius = 70
        return view
    }()

    private var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "checkmark")
        view.contentMode = .scaleAspectFill
        return view
    }()

    private var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center

        let attributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.strokeWidth: -5.0,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Heavy", size: 55)!
        ]
        label.attributedText = NSAttributedString(string: "Hotdog", attributes: attributes)

        return label
    }()
}

