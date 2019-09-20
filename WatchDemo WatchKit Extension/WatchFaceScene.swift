//
//  WatchFaceScene.swift
//  WatchDemo WatchKit Extension
//
//  Created by Waldemar on 19/09/2019.
//  Copyright © 2019 waldemarleo. All rights reserved.
//

import Foundation
import SpriteKit

class WatchFaceScene: SKScene {
    typealias UpdateHandler = () -> Void
    var updateHandler: UpdateHandler?
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        self.updateHandler?()
    }
}
