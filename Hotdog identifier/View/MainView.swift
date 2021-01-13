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
        let safeArea = self.safeAreaLayoutGuide

        self.addSubview(welcomeView)
        welcomeView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        welcomeView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        welcomeView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        welcomeView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        self.addSubview(notHotdogView)
        notHotdogView.leftAnchor.constraint(equalTo: safeArea.leftAnchor).isActive = true
        notHotdogView.rightAnchor.constraint(equalTo: safeArea.rightAnchor).isActive = true
        notHotdogView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        notHotdogView.heightAnchor.constraint(equalToConstant: 250).isActive = true
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

    public func showNotHotdogView() {
        notHotdogView.isHidden = false
    }

    public func hideNotHotdogView() {
        notHotdogView.isHidden = true
    }

    public var welcomeView: WelcomeView = {
        let welcomeView = WelcomeView()
        welcomeView.translatesAutoresizingMaskIntoConstraints = false
        welcomeView.isHidden = true
        return welcomeView
    }()

    private var notHotdogView: NotHotDogView = {
        let notHotdogView = NotHotDogView()
        notHotdogView.translatesAutoresizingMaskIntoConstraints = false
        notHotdogView.isHidden = true
        return notHotdogView
    }()
}
