//
//  ContentView.swift
//  Pomodoro Timer
//
//  Created by Tarik Merrylees on 17/07/2022.
//

import SwiftUI
import Foundation
import AVFoundation




struct ContentView: View {
    @State var countdownTimer = 1500 // 25 minutes
    @State var timerRunning = false
    @State var brakeTime = false
    @State var player: AVAudioPlayer?
    
    func playAudio() -> Void {
        let pathToSound = Bundle.main.path(forResource: "mixkit-sci-fi-confirmation-914", ofType: "wav")!
        let url = URL(fileURLWithPath: pathToSound)
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }
        catch {
            print(error)
        }
    }
    
    func convertToDoubleDigits(time: Int) -> String {
        var returnValue = "\(time)"
        if time < 10 {
            returnValue = "0" + returnValue
        }
        
        return returnValue
    }
    
    func secondsToMinutesSeconds(seconds: Int) -> String {
        let min = convertToDoubleDigits(time: (seconds % 3600) / 60)
        let sec = convertToDoubleDigits(time: (seconds % 3600) % 60)
    
        return "\(min):\(sec)"
    }
    
    let timer = Timer.publish(
        every: 1,
        on: .main,
        in: .common
    ).autoconnect()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            if timerRunning && !brakeTime {Color.red.ignoresSafeArea()}
            if timerRunning && brakeTime {Color.green.ignoresSafeArea()}
            
            
            VStack(spacing:30) {
                let displayed_time = secondsToMinutesSeconds(seconds: countdownTimer)
                
                Text("\(displayed_time)")
                    .padding()
                    .onReceive(timer) { _ in
                        if countdownTimer > 0 && timerRunning {
                            countdownTimer -= 1
                        }
                        if !brakeTime && countdownTimer == 0 {
                            playAudio()
                            brakeTime = true
                            countdownTimer = 301 // 5 minutes
                            countdownTimer -= 1
                        }
                        if brakeTime && countdownTimer == 0 {
                            playAudio()
                            brakeTime = false
                            countdownTimer = 1501
                        }
                    }
                    .font(.system(size: 80, weight: .bold))
                    .opacity(0.8)
                    .background(Color.white)
                    .cornerRadius(10)
//                    .frame(width: 100)
                
                HStack(spacing:30) {
                    if !timerRunning {
                        Button("Start") {
                            timerRunning = true
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(4)
                    } else {
                        Button("Pause") {
                            timerRunning = false
                        }
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(4)
                    }

                    Button("Reset") {
                        countdownTimer = 1500
                        timerRunning = false
                    }
                    .foregroundColor(.red)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(4)
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
