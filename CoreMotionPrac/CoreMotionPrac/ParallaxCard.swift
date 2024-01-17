
import SwiftUI
import CoreMotion

// CMMotionManager
class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    @Published var relativeAcceleration: CMAcceleration = .init()
    
    private var neutralAcceleration: CMAcceleration?
    
    init() {
        startAccelerometers()
    }
    
    private func startAccelerometers() {
        guard motionManager.isAccelerometerAvailable else { return }
        let maxScreenRefreshRate = UIScreen.main.maximumFramesPerSecond // max 주사율
        motionManager.accelerometerUpdateInterval = 1.0 / Double(maxScreenRefreshRate) // 기기별 주사율에 따른 가속도 갱신
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] (data, error) in
            guard let data = data else { return }
            
            if let neutral = self?.neutralAcceleration {
                // 기기의 현재 가속도계 값 계산
                self?.relativeAcceleration = CMAcceleration(
                    x: data.acceleration.x - neutral.x,
                    y: data.acceleration.y - neutral.y,
                    z: data.acceleration.z - neutral.z
                )
            } else {
                // 현재 가속도계 값을 중립으로
                self?.neutralAcceleration = data.acceleration
            }
        }
    }
}

struct ParallaxCard: View {
    @ObservedObject var motionManager = MotionManager()
    
    @State var motion: CMDeviceMotion? = nil
//    let motionManager = CMMotionManager()
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 300, height: 300)
                .foregroundStyle(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 0)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 250, height: 250)
                .foregroundStyle(Color.gray)
                .offset(x: motionManager.relativeAcceleration.x * 10, y: motionManager.relativeAcceleration.y * 10)
                .rotation3DEffect(
                    motion != nil ? .degrees(Double(motion!.attitude.pitch) * 5 / .pi) : .degrees(0),
                    axis: (
                        x: motionManager.relativeAcceleration.x, y: motionManager.relativeAcceleration.y, z: 0))
                .shadow(color: .black.opacity(0.3),
                        radius: 1,
                        x: motionManager.relativeAcceleration.x * 5, y: motionManager.relativeAcceleration.y * 5)
            
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 200, height: 200)
                .foregroundStyle(Color.black)
                .offset(x: motionManager.relativeAcceleration.x * 15, y: motionManager.relativeAcceleration.y * 15)
                .rotation3DEffect(
                    motion != nil ? .degrees(Double(motion!.attitude.pitch) * 5 / .pi) : .degrees(0),
                    axis: (
                        x: motionManager.relativeAcceleration.x, y: motionManager.relativeAcceleration.y, z: 0))
                .shadow(color: .black.opacity(0.35),
                        radius: 1,
                        x: motionManager.relativeAcceleration.x * 7, y: motionManager.relativeAcceleration.y * 7)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 140, height: 140)
                .foregroundStyle(Color.white)
                .offset(x: motionManager.relativeAcceleration.x * 20, y: motionManager.relativeAcceleration.y * 20)
                .rotation3DEffect(
                    motion != nil ? .degrees(Double(motion!.attitude.pitch) * 5 / .pi) : .degrees(0),
                    axis: (
                        x: motionManager.relativeAcceleration.x, y: motionManager.relativeAcceleration.y, z: 0))
                .shadow(color: .black.opacity(0.5),
                        radius: 1,
                        x: motionManager.relativeAcceleration.x * 9, y: motionManager.relativeAcceleration.y * 9)
            
                .overlay(alignment: .bottom) {
                    Image(systemName: "apple.logo").resizable().scaledToFit()
                        .offset(x: motionManager.relativeAcceleration.x * 25, y: motionManager.relativeAcceleration.y * 25)
                        .rotation3DEffect(
                            motion != nil ? .degrees(Double(motion!.attitude.pitch) * 5 / .pi) : .degrees(0),
                            axis: (
                                x: motionManager.relativeAcceleration.x, y: motionManager.relativeAcceleration.y, z: 0))
                        .shadow(color: .black.opacity(0.5),
                                radius: 1,
                                x: motionManager.relativeAcceleration.x * 11, y: motionManager.relativeAcceleration.y * 11)
                }
        }
//        .onAppear {
//            if motionManager.isDeviceMotionAvailable {
//                let maxScreenRefreshRate = UIScreen.main.maximumFramesPerSecond // max 주사율
//                print(maxScreenRefreshRate)
//                
//                self.motionManager.accelerometerUpdateInterval = 1.0 / Double(maxScreenRefreshRate) // 기기별 주사율에 따른 가속도 갱신
//                self.motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
//                    if let validData = data {
//                        self.motion = validData
//                    }
//                }
//            } else { return }
//            
//        }
        
    }
}

#Preview {
    ParallaxCard()
}
