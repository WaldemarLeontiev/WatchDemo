//
//  InterfaceController.swift
//  WatchDemo WatchKit Extension
//
//  Created by Waldemar on 17/09/2019.
//  Copyright © 2019 waldemarleo. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

}

// MARK: - UI actions
extension InterfaceController {
    @IBAction func endWorkoutSessionButtonPressed() {
        WorkoutSessionManager.shared.stop()
    }
}
