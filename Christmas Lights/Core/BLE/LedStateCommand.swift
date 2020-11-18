//
//  GyverStateCommand.swift
//  Christmas Lights
//
//  Created by Mixaill on 08.11.2020.
//  Copyright © 2020 M-Technologies. All rights reserved.
//

import Foundation

class LedStateCommand: BLECommand {
    
    override func handleResponse() -> Bool {
        guard let response = LightsStateResponse(rawData: rawResponse) else {
            return false
        }
        
        self.response = response
        
        return true
    }
    
}
