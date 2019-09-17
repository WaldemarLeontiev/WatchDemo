//
//  WorkoutSessionManager.swift
//  WatchDemo WatchKit Extension
//
//  Created by Waldemar on 17/09/2019.
//  Copyright © 2019 waldemarleo. All rights reserved.
//

import HealthKit

class WorkoutSessionManager: NSObject {
    static let shared = WorkoutSessionManager()
    private override init() {}
    
    private(set) var workoutSession: HKWorkoutSession?
    private(set) lazy var healthStore = HKHealthStore()
    
    func start() {
        do {
            let configuration = HKWorkoutConfiguration()
            configuration.activityType = .walking
            configuration.locationType = .indoor
            let workoutSession = try HKWorkoutSession(healthStore: self.healthStore, configuration: configuration)
            workoutSession.delegate = self
            workoutSession.startActivity(with: nil)
            self.workoutSession = workoutSession
        } catch {
            print("Can't init workout session: \(error.localizedDescription)")
        }
    }
    func stop() {
        self.workoutSession?.stopActivity(with: nil)
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutSessionManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        print("Workout session state: \(fromState.rawValue) → \(toState.rawValue)")
        if toState == .stopped {
            self.workoutSession?.end()
        }
    }
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed: \(error.localizedDescription)")
    }
}
