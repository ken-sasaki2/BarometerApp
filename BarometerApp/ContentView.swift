//
//  ContentView.swift
//  BarometerApp
//
//  Created by sasaki.ken on 2022/04/28.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    private let altimatorDataStore = AltimatorDataStore()
    
    var body: some View {
        Button {
            altimatorDataStore.startUpdate()
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


final class AltimatorDataStore {
    var altimeter: CMAltimeter?
    
    init() {
        altimeter = CMAltimeter()
    }
    
    func doResert() {
        stopUpdate()
        startUpdate()
    }
    
    func startUpdate() {
        guard let altimeter = altimeter else {
            return
        }
        
        // CMAltimeterを許可しないといけない
        
        
        if CMAltimeter.isRelativeAltitudeAvailable() {
            altimeter.startRelativeAltitudeUpdates(to: OperationQueue.main) { data, error in
                if error == nil {
                    let pressure = data?.pressure.doubleValue
                    let altitude = data?.relativeAltitude.doubleValue
                    
                    print("気圧", pressure as Any)
                    print("高度", altitude as Any)
                } else {
                    // エラー処理
                }
            }
        }
    }
    
    func stopUpdate() {
        altimeter?.stopRelativeAltitudeUpdates()
    }
}
