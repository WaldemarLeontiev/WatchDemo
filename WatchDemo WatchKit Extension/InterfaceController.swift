//
//  InterfaceController.swift
//  WatchDemo WatchKit Extension
//
//  Created by Waldemar on 17/09/2019.
//  Copyright © 2019 waldemarleo. All rights reserved.
//

import WatchKit
import Foundation
import SpriteKit


class InterfaceController: WKInterfaceController {
    
    // MARK: - UI objects
    @IBOutlet weak var sceneInteface: WKInterfaceSKScene!
    private let scene = WatchFaceScene(size: CGSize(width: 300, height: 300))
    
    // MARK: - Nodes
    private lazy var hourHandNode = self.make(handNode: .hour)
    private lazy var minuteHandNode = self.make(handNode: .minute)
    private lazy var secondHandNode = self.make(handNode: .second)
    
    // MARK: - WKInterfaceController overrides
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        self.setupHands()
        self.setupScene()
    }
    
    // MARK: - Private
    private var presentedTimestamp: Int?
}

// MARK: - UI actions
extension InterfaceController {
    @IBAction func endWorkoutSessionButtonPressed() {
        WorkoutSessionManager.shared.stop()
    }
}

// MARK: - UI
extension InterfaceController {
    private func setupScene() {
        self.sceneInteface.presentScene(self.scene)
        self.scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.scene.updateHandler = { [weak self] in
            self?.updateTimeIfNeeded()
        }
    }
    private func setupHands() {
        self.scene.addChild(self.hourHandNode)
        self.scene.addChild(self.minuteHandNode)
        self.scene.addChild(self.secondHandNode)
    }
    private func updateTimeIfNeeded() {
        let date = Date()
        let timestamp = Int(date.timeIntervalSince1970)
        if timestamp != self.presentedTimestamp {
            self.presentedTimestamp = timestamp
            self.updateTime(with: date)
        }
    }
    private func updateTime(with date: Date) {
        let startOfDay = Calendar.current.startOfDay(for: date)
        let secondsOfDay = date.timeIntervalSince(startOfDay)
        let hoursProgress = secondsOfDay / (3600 * 24)
        let minutesProgress = secondsOfDay / 3600 - (hoursProgress * 24).rounded(.down)
        let secondsProgress = secondsOfDay / 60 - (hoursProgress * 24).rounded(.down) * 60 - (minutesProgress * 60).rounded(.down)
        self.set(progress: hoursProgress * 2, of: self.hourHandNode)
        self.set(progress: minutesProgress, of: self.minuteHandNode)
        self.set(progress: secondsProgress, of: self.secondHandNode)
    }
    private func set(progress: Double, of node: SKNode) {
        node.zRotation = -2 * CGFloat.pi * CGFloat(progress)
    }
}

// MARK: - Hands
extension InterfaceController {
    private func make(handNode hand: Hand) -> SKShapeNode {
        var points = [CGPoint(x: 0, y: 0),
                      CGPoint(x: 0, y: hand.length)]
        let handNode = SKShapeNode(points: &points, count: points.count)
        handNode.lineWidth = hand.width
        return handNode
    }
    private enum Hand {
        case hour
        case minute
        case second
        
        var length: CGFloat {
            switch self {
            case .hour:
                return 100
            case .minute:
                return 130
            case .second:
                return 150
            }
        }
        var width: CGFloat {
            switch self {
            case .hour:
                return 8
            case .minute:
                return 5
            case .second:
                return 1
            }
        }
    }
}
