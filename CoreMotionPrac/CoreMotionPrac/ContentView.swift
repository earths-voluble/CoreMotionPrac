
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

struct ContentView: View {
    @State var motion: CMDeviceMotion? = nil
    let motionManager = CMMotionManager()
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 300, height: 300)
                .foregroundStyle(Color.white)
                .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 0)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 250, height: 250)
                .foregroundStyle(Color.gray)
                .offset(
                    x: motion != nil ? CGFloat(motion!.gravity.x * 20) : 0,
                    y: motion != nil ? CGFloat(-motion!.gravity.y * 20) : 0)
                .rotation3DEffect(
                    motion != nil ? .degrees(Double(motion!.attitude.pitch) * 5 / .pi) : .degrees(0),
                    axis: (
                        x: motion != nil ? -motion!.gravity.y : 0,
                        y: motion != nil ? motion!.gravity.x : 0, z: 0))
                .shadow(color: .black.opacity(0.3),
                        radius: 1,
                        x: motion != nil ? CGFloat(-motion!.gravity.y * 3) : 0,
                        y: motion != nil ? CGFloat(motion!.gravity.x * 3) : 0)
            
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 200, height: 200)
                .foregroundStyle(Color.black)
                .offset(
                    x: motion != nil ? CGFloat(motion!.gravity.x * 27) : 0,
                    y: motion != nil ? CGFloat(-motion!.gravity.y * 27) : 0)
                .rotation3DEffect(
                    motion != nil ? .degrees(Double(motion!.attitude.pitch) * 5 / .pi) : .degrees(0),
                    axis: (
                        x: motion != nil ? -motion!.gravity.y : 0,
                        y: motion != nil ? motion!.gravity.x : 0, z: 0))
                .shadow(color: .black.opacity(0.35),
                        radius: 1,
                        x: motion != nil ? CGFloat(-motion!.gravity.y * 5) : 0,
                        y: motion != nil ? CGFloat(motion!.gravity.x * 5) : 0)
            
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .frame(width: 140, height: 140)
                .foregroundStyle(Color.white)
                .offset(
                    x: motion != nil ? CGFloat(motion!.gravity.x * 40) : 0,
                    y: motion != nil ? CGFloat(-motion!.gravity.y * 40) : 0)
                .rotation3DEffect(
                    motion != nil ? .degrees(Double(motion!.attitude.pitch) * 5 / .pi) : .degrees(0),
                    axis: (
                        x: motion != nil ? -motion!.gravity.y : 0,
                        y: motion != nil ? motion!.gravity.x : 0, z: 0))
                .shadow(color: .black.opacity(0.5),
                        radius: 1,
                        x: motion != nil ? CGFloat(-motion!.gravity.y * 7) : 0,
                        y: motion != nil ? CGFloat(motion!.gravity.x * 7) : 0)
            
                .overlay(alignment: .bottom) {
                    Image(systemName: "person").resizable().scaledToFit()
                        .offset(
                            x: motion != nil ? CGFloat(motion!.gravity.x * 40) : 0,
                            y: motion != nil ? CGFloat(-motion!.gravity.y * 40) : 0)
                        .rotation3DEffect(
                            motion != nil ? .degrees(Double(motion!.attitude.pitch) * 5 / .pi) : .degrees(0),
                            axis: (
                                x: motion != nil ? -motion!.gravity.y : 0,
                                y: motion != nil ? motion!.gravity.x : 0, z: 0))
                        .shadow(color: .black.opacity(0.5),
                                radius: 1,
                                x: motion != nil ? CGFloat(-motion!.gravity.x * 9) : 0,
                                y: motion != nil ? CGFloat(motion!.gravity.y * 9) : 0)
                    
                    
                }
        }
        .onAppear {
            if motionManager.isDeviceMotionAvailable {
                let maxScreenRefreshRate = UIScreen.main.maximumFramesPerSecond // max 주사율
                print(maxScreenRefreshRate)
                
                self.motionManager.accelerometerUpdateInterval = 1.0 / Double(maxScreenRefreshRate) // 기기별 주사율에 따른 가속도 갱신
                self.motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                    if let validData = data {
                        self.motion = validData
                    }
                }
            } else { return }
            
        }
        
    }
}

#Preview {
    ContentView()
}
