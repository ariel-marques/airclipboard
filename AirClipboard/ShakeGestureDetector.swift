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
    private var movementHistory: [(time: Date, deltaX: CGFloat)] = []

    private let shakeThreshold: CGFloat = 30.0
    private let requiredShakeCount = 3
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
        let environment = AppEnvironment.shared

        guard environment.enableShakeGesture else {
            lastPosition = nil
            movementHistory.removeAll()
            return
        }

        guard isModifierKeyPressed(selectedModifier: environment.shakeModifier) else {
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
            let deltaX = currentPosition.x - lastPosition.x
            let deltaY = abs(currentPosition.y - lastPosition.y)
            let delta = max(abs(deltaX), deltaY)

            if delta > shakeThreshold {
                movementHistory.append((time: now, deltaX: deltaX))
                cleanupOldMovements()

                if countDirectionChanges() >= requiredShakeCount {
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

    private func countDirectionChanges() -> Int {
        guard movementHistory.count >= 2 else { return 0 }
        var changes = 0

        for i in 1..<movementHistory.count {
            let prev = movementHistory[i - 1].deltaX
            let curr = movementHistory[i].deltaX
            if (prev > 0 && curr < 0) || (prev < 0 && curr > 0) {
                changes += 1
            }
        }

        return changes
    }

    private func triggerShakeDetected() {
        print("🎯 Shake detectado com modificador correto!")

        DispatchQueue.main.async {
            self.showVisualFeedbackAtCursor()

            if let controller = AppDelegate.shared?.floatingWindowController {
                controller.showWindow(nil)
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }

    private func showVisualFeedbackAtCursor() {
        let size: CGFloat = 60
        let duration: TimeInterval = 0.35

        // let screenFrame = NSScreen.main?.frame ?? .zero
        let mouseLocation = NSEvent.mouseLocation

        let window = NSWindow(
            contentRect: NSRect(x: mouseLocation.x - size / 2, y: mouseLocation.y - size / 2, width: size, height: size),
            styleMask: [],
            backing: .buffered,
            defer: false
        )

        window.isOpaque = false
        window.backgroundColor = .clear
        window.level = .floating
        window.ignoresMouseEvents = true
        window.hasShadow = false

        let pulseView = NSView(frame: NSRect(x: 0, y: 0, width: size, height: size))
        pulseView.wantsLayer = true
        pulseView.layer?.cornerRadius = size / 2
        pulseView.layer?.backgroundColor = NSColor.systemBlue.withAlphaComponent(0.25).cgColor
        window.contentView = pulseView

        window.makeKeyAndOrderFront(nil)

        NSAnimationContext.runAnimationGroup({ context in
            context.duration = duration
            pulseView.animator().alphaValue = 0
        }, completionHandler: {
            window.orderOut(nil)
        })
    }

    private func isModifierKeyPressed(selectedModifier: String) -> Bool {
        switch selectedModifier {
        case "shift":
            return NSEvent.modifierFlags.contains(.shift)
        case "command":
            return NSEvent.modifierFlags.contains(.command)
        case "option":
            return NSEvent.modifierFlags.contains(.option)
        default:
            return false
        }
    }
}
