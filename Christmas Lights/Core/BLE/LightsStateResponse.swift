//
//  GyverStateResponse.swift
//  Christmas Lights
//
//  Created by Mixaill on 08.11.2020.
//  Copyright © 2020 M-Technologies. All rights reserved.
//

import Foundation

enum LedMode: Int {
    case off = 0
    case all
    case allShuffle
    case user
    case userShuffle
}

class LightsStateResponse: BLEResponse {

    var isNotification = false
    var effectId = 0
    var ledMode:LedMode = .all
    var glitterEnabled = false
    var backgroudEnabled = false
    var candleEnabled = false
    
    override init?(rawData: Data?) {
        super.init(rawData: rawData)
        
        guard let data = dataArray else {
            return nil
        }
        
        guard data.count >= 7 && (data[0] == 0xA4 || data[0] == 0xA5) else {
            return nil
        }
        
        guard data.count-2 == data[1] else {
            return nil
        }
        
        isNotification = data[0] == 0xA4
        effectId = Int(data[2])
        ledMode = LedMode(rawValue: Int(data[3])) ?? .all
        glitterEnabled = Int(data[4]) > 0
        backgroudEnabled = Int(data[5]) > 0
        candleEnabled = Int(data[6]) > 0
    }
}
