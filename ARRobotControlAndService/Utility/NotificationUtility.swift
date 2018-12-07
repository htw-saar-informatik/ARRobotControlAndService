//
//  NotificationUtility.swift
//  ARRobotControlAndService
//
//  Created by Marco Becker on 07.12.18.
//  Copyright © 2018 Marco Becker. All rights reserved.
//

import Foundation
import UIKit
import SwiftMessages

// Utility for displaying global notifications within the app
enum NotificationUtility{
    static func showPrettyMessage(with body: String, button buttontext: String, style:Theme){
        var config = SwiftMessages.Config()
        config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show { () -> UIView in
            let view = MessageView.viewFromNib(layout: .statusLine)
            view.configureTheme(style)
            view.configureContent(title: nil, body: body, iconImage: UIImage(), iconText: nil, buttonImage: UIImage(), buttonTitle: nil, buttonTapHandler: nil)
            return view
        }
    }
}
