//
//  WelcomeView.swift
//  Hotdog identifier
//
//  Created by Oskar Figiel on 11/01/2021.
//

import UIKit

final class WelcomeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(seeFoodLabel)
        seeFoodLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        seeFoodLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        seeFoodLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        seeFoodLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true

        self.addSubview(shazamFoodLabel)
        shazamFoodLabel.topAnchor.constraint(equalTo: seeFoodLabel.bottomAnchor).isActive = true
        shazamFoodLabel.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        shazamFoodLabel.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        shazamFoodLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        self.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: shazamFoodLabel.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        stackView.addArrangedSubview(burgerView)
        stackView.addArrangedSubview(sandwichView)
        stackView.addArrangedSubview(soupView)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        return stackView
    }()

    public var burgerView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "burger"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()

    public var sandwichView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "sandwich"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()

    public var soupView: UIImageView = {
        let image = UIImageView(image: UIImage(named: "soup"))
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        return image
    }()

    public var seeFoodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        let strokeTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
          NSAttributedString.Key.strokeColor : UIColor.black,
          NSAttributedString.Key.strokeWidth : -5.0,
          NSAttributedString.Key.font : UIFont.systemFont(ofSize: 70, weight: .heavy)]
          as [NSAttributedString.Key : Any]

        label.attributedText = NSMutableAttributedString(string: "SEEFOOD", attributes: strokeTextAttributes)
        label.backgroundColor = UIColor(red: 200/255, green: 30/255, blue: 40/255, alpha: 1.0)
        return label
    }()

    public var shazamFoodLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = UIColor(red: 200/255, green: 30/255, blue: 40/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.text = "\"The Shazam for Food\""
        label.backgroundColor = .white
        return label
    }()
}
