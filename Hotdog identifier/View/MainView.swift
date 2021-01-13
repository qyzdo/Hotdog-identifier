//
//  MainView.swift
//  Hotdog identifier
//
//  Created by Oskar Figiel on 11/01/2021.
//

import UIKit

final class MainView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(welcomeView)
        let safeArea = self.safeAreaLayoutGuide
        welcomeView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        welcomeView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        welcomeView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        welcomeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public func showWelcomeView() {
        welcomeView.isHidden = false
        welcomeView.showAnimation()
    }

    public func hideWelcomeView() {
        welcomeView.isHidden = true
    }

    public var welcomeView: WelcomeView = {
        let welcomeView = WelcomeView()
        welcomeView.translatesAutoresizingMaskIntoConstraints = false
        welcomeView.isHidden = true
        return welcomeView
    }()
}
