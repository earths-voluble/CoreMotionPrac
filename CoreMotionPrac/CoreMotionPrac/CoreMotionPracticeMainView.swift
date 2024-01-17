//
//  CoreMotionPracticeMainView.swift
//  CoreMotionPrac
//
//  Created by 이보한 on 2024/1/17.
//

import SwiftUI

struct CoreMotionPracticeMainView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, CoreMotion!")
                    .bold()
                NavigationLink(destination: ParallaxCard()) {
                    Text("ParallaxCard")
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 60, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.pink))
                }
                .navigationBarHidden(true)
                NavigationLink(destination: MotionInfo()) {
                    Text("MotionInfo")
                        .foregroundColor(Color.white)
                        .frame(width: 150, height: 60, alignment: .center)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color.pink))
                }
                .navigationBarHidden(true)
            }
        }
    }
}
    struct ButtonDesign: View {
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color.yellow)
                    .frame(width: 360, height: 200)
                Text("나를 눌러줘!")
                    .foregroundColor(.red)
            }
        }
    }
#Preview {
    CoreMotionPracticeMainView()
}
