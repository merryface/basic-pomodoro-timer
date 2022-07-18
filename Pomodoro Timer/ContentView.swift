//
//  ContentView.swift
//  Pomodoro Timer
//
//  Created by Tarik Merrylees on 17/07/2022.
//

import SwiftUI
import Foundation

func secondsToMinutesSeconds(_ seconds: Int) -> (Int, Int) {
    return ((seconds % 3600) / 60, (seconds % 3600) % 60)
}

struct ContentView: View {
    @State var countdownTimer = 25*60 // 25 minutes
    @State var timerRunning = false
    @State var brakeTime = false
    
    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        ZStack {
            if timerRunning && !brakeTime {Color.red.ignoresSafeArea()}
            if timerRunning && brakeTime {Color.green.ignoresSafeArea()}
            
            VStack(spacing:30) {
                Text("\(countdownTimer)")
                    .padding()
                    .onReceive(timer) { _ in
                        if countdownTimer > 0 && timerRunning {
                            countdownTimer -= 1
                        }
                        if !brakeTime && countdownTimer == 0 {
                            brakeTime = true
                            countdownTimer = 301 // 5 minutes
                            countdownTimer -= 1
                        }
                        if brakeTime && countdownTimer == 0 {
                            timerRunning = false
                            brakeTime = false
                        }
                    }
                    .font(.system(size: 80, weight: .bold))
                    .opacity(0.8)
                    .background(Color.white)
                    .cornerRadius(20)
                
                HStack(spacing:30) {
                    Button("Start") {
                        timerRunning = true
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    Button("Pause") {
                        timerRunning = false
                    }
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    
                    Button("Reset") {
                        countdownTimer = 5
                    }
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
