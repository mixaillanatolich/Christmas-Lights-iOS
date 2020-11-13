//
//  SetModeCommand.swift
//  Christmas-Lights
//
//  Created by Mixaill on 09.11.2020.
//  Copyright © 2020 M-Technologies. All rights reserved.
//

import UIKit

class SetModeCommand: BLECommand {

    override func handleResponse() -> Bool {
        guard let response = CommonStatusResponse(rawData: rawResponse) else {
            return false
        }
        self.response = response
        return true
    }
    
}
