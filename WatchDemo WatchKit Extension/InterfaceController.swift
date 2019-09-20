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
    @IBOutlet weak var endSessionButton: WKInterfaceButton!
    private let scene = WatchFaceScene(size: CGSize(width: InterfaceController.sceneSize,
                                                    height: InterfaceController.sceneSize))
    
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
    override func willActivate() {
        super.willActivate()
        self.isActivated = true
    }
    override func didDeactivate() {
        super.didDeactivate()
        self.isActivated = false
    }
    
    // MARK: - Private
    // MARK: Settings
    static private let sceneSize: CGFloat = 100
    private let isHideInterfaceEnabled = true
    // MARK: Vars
    private var presentedTimestamp: Int?
    private var isActivated: Bool = false {
        didSet {
            if self.isActivated == false {
                self.isInterfaceHidden = true
            }
        }
    }
    private var isInterfaceHidden = false {
        didSet {
            if isHideInterfaceEnabled {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                    if let isInterfaceHidden = self?.isInterfaceHidden {
                        self?.setInterface(hidden: isInterfaceHidden)
                    }
                }
            }
        }
    }
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
        self.scene.backgroundColor = .black
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
            if self.isActivated && self.isInterfaceHidden {
                self.isInterfaceHidden = false
            }
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
    private func setInterface(hidden: Bool) {
        self.sceneInteface.setHidden(hidden)
        self.endSessionButton.setHidden(hidden)
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
            let secondHandLength = InterfaceController.sceneSize / 2
            switch self {
            case .hour:
                return secondHandLength * 0.6
            case .minute:
                return secondHandLength * 0.8
            case .second:
                return secondHandLength
            }
        }
        var width: CGFloat {
            let secondHandWidth = InterfaceController.sceneSize / 100
            switch self {
            case .hour:
                return secondHandWidth * 3
            case .minute:
                return secondHandWidth * 2
            case .second:
                return secondHandWidth
            }
        }
    }
}
