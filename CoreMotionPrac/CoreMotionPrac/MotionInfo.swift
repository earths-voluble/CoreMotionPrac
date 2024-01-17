//
//  MotionInfo.swift
//  CoreMotionPrac
//
//  Created by 이보한 on 2024/1/17.
//

import SwiftUI
import CoreMotion

class MotionInfoManager: ObservableObject {
    private var motionManager = CMMotionManager()
    @Published var attitude: CMAttitude?
    @Published var rotationRate: CMRotationRate?
    @Published var gravity: CMAcceleration?
    @Published var userAcceleration: CMAcceleration?

    init() {
        startDeviceMotion()
    }

    private func startDeviceMotion() {
        guard motionManager.isDeviceMotionAvailable else { return }

        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] (motion, error) in
            guard let motion = motion else { return }
            DispatchQueue.main.async {
                self?.attitude = motion.attitude
                self?.rotationRate = motion.rotationRate
                self?.gravity = motion.gravity
                self?.userAcceleration = motion.userAcceleration
            }
        }
    }
}

struct MotionInfo: View {
    @ObservedObject var motionManager = MotionInfoManager()

    var body: some View {
        VStack(spacing: 10) {
            Text("Device Motion Data").font(.headline)
            Group {
                Text("Attitude")
                Text("Roll: \(motionManager.attitude?.roll ?? 0, specifier: "%.2f")")
                Text("Pitch: \(motionManager.attitude?.pitch ?? 0, specifier: "%.2f")")
                Text("Yaw: \(motionManager.attitude?.yaw ?? 0, specifier: "%.2f")")
            }
            Group {
                Text("Rotation Rate")
                Text("x: \(motionManager.rotationRate?.x ?? 0, specifier: "%.2f")")
                Text("y: \(motionManager.rotationRate?.y ?? 0, specifier: "%.2f")")
                Text("z: \(motionManager.rotationRate?.z ?? 0, specifier: "%.2f")")
            }
            Group {
                Text("Gravity")
                Text("x: \(motionManager.gravity?.x ?? 0, specifier: "%.2f")")
                Text("y: \(motionManager.gravity?.y ?? 0, specifier: "%.2f")")
                Text("z: \(motionManager.gravity?.z ?? 0, specifier: "%.2f")")
            }
            Group {
                Text("User Acceleration")
                Text("x: \(motionManager.userAcceleration?.x ?? 0, specifier: "%.2f")")
                Text("y: \(motionManager.userAcceleration?.y ?? 0, specifier: "%.2f")")
                Text("z: \(motionManager.userAcceleration?.z ?? 0, specifier: "%.2f")")
            }
        }
        .padding()
    }
}

#Preview {
    MotionInfo()
}
