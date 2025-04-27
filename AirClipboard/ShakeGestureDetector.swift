//
//  ShakeGestureDetector.swift
//  AirClipboard
//
//  Created by Ariel Marques on 28/04/25.
//

import Foundation
import AppKit

class ShakeGestureDetector {
    static let shared = ShakeGestureDetector()

    private var lastPosition: NSPoint?
    private var lastShakeTime: Date = .distantPast
    private var movementHistory: [(time: Date, delta: CGFloat)] = []

    private let shakeThreshold: CGFloat = 40.0
    private let requiredShakeCount = 8
    private let shakeTimeWindow: TimeInterval = 0.5
    private let cooldownDuration: TimeInterval = 1.5

    private var monitor: Any?

    private init() {}

    func startMonitoring() {
        stopMonitoring()

        monitor = NSEvent.addGlobalMonitorForEvents(matching: .mouseMoved) { [weak self] event in
            self?.handleMouseMovement(event)
        }
    }

    func stopMonitoring() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }

    private func handleMouseMovement(_ event: NSEvent) {
        guard NSEvent.modifierFlags.contains(.shift) else {
            lastPosition = nil
            movementHistory.removeAll()
            return
        }

        let now = Date()
        guard now.timeIntervalSince(lastShakeTime) > cooldownDuration else {
            return
        }

        let currentPosition = event.locationInWindow

        if let lastPosition = lastPosition {
            let deltaX = abs(currentPosition.x - lastPosition.x)
            let deltaY = abs(currentPosition.y - lastPosition.y)
            let delta = max(deltaX, deltaY)

            if delta > shakeThreshold {
                movementHistory.append((time: now, delta: delta))
                cleanupOldMovements()

                if movementHistory.count >= requiredShakeCount {
                    triggerShakeDetected()
                    lastShakeTime = now
                    movementHistory.removeAll()
                    self.lastPosition = nil
                    return
                }
            }
        }

        self.lastPosition = currentPosition
    }

    private func cleanupOldMovements() {
        let now = Date()
        movementHistory = movementHistory.filter { now.timeIntervalSince($0.time) <= shakeTimeWindow }
    }

    private func triggerShakeDetected() {
        print("🎯 Shake forte detectado com SHIFT!")

        DispatchQueue.main.async {
            if let controller = AppDelegate.shared?.floatingWindowController {
                controller.showWindow(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
}
