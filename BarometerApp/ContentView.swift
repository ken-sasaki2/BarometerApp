//
//  ContentView.swift
//  BarometerApp
//
//  Created by sasaki.ken on 2022/04/28.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    private let altimator = Altimator()
    
    var body: some View {
        Button {
            altimator.startUpdate()
        } label: {
            Text("気圧計起動")
                .frame(width: 300, height: 44)
                .background(.blue)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .semibold, design: .default))
                .cornerRadius(25)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


final class Altimator {
    var altimeter: CMAltimeter?
    
    init() {
        altimeter = CMAltimeter()
    }
    
    func startUpdate() {
        guard let altimeter = altimeter else {
            return
        }
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { data, error in
                if error == nil {
                    let altitude = data?.relativeAltitude.doubleValue
                    guard let pressure = data?.pressure.doubleValue else {
                        return
                    }
                    
                    print("気圧", pressure * 10)
                    print("高度", altitude as Any)
                    
                    // Save to database...
                    
                    self.stopUpdate()
                } else {
                    // Error hundring...
                }
            }
        }
    }
    
    func stopUpdate() {
        altimeter?.stopRelativeAltitudeUpdates()
    }
}
