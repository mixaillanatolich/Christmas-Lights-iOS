//
//  LedControlManager.swift
//  Christmas Lights
//
//  Created by Mixaill on 08.11.2020.
//  Copyright © 2020 M-Technologies. All rights reserved.
//

import UIKit


let LEDController = LedControlManager.sharedInstance

class LedControlManager: NSObject {

  //  fileprivate let divider: UInt8 = 0x2c
    
    public static let sharedInstance: LedControlManager = {
        let instance = LedControlManager()
        return instance
    }()
    
    override init() {
        super.init()
    }
    
    func sendPing(callback: @escaping (_ isSuccess: Bool) -> Void) {
        
        makeCommandAndSend(data: Data([0x00]),
                           isWaitResponse: true, isWriteWithResponse: true,
                           command: GyverStateCommand.self) { (status, response) in
                            
                            callback(status && response != nil)
        }
        
    }
    
    func loadSetting(callback: @escaping (_ isSuccessful: Bool, _ response: GyverStateResponse?) -> Void) {
        
        
        makeCommandAndSend(data: Data([0x01]),
                           isWaitResponse: true, isWriteWithResponse: true,
                           command: GyverStateCommand.self) { (status, response) in
                            
                            callback(status, response as? GyverStateResponse)
        }

    }
    
    func changeSetting(command: Data, callback: @escaping (_ isSuccess: Bool) -> Void) {
        
        makeCommandAndSend(data: command,
                           isWaitResponse: false, isWriteWithResponse: false,
                           command: BLECommand.self) { (status, response) in
                            
                            callback(status)
        }
        
    }
    
    func changePreset(presetId id: Int, callback: @escaping (_ isSuccessful: Bool, _ response: GyverStateResponse?) -> Void) {
        
        let commandId:UInt8 = 0x03
        let presetId:UInt8 = UInt8(id)
        
        makeCommandAndSend(data: Data([commandId, presetId]),
                           isWaitResponse: true, isWriteWithResponse: true,
                           command: GyverStateCommand.self) { (status, response) in
                            
                            callback(status, response as? GyverStateResponse)
        }
        
    }
    
    func changeMode(modeId id: Int, callback: @escaping (_ isSuccessful: Bool, _ response: GyverStateResponse?) -> Void) {
        
        let commandId:UInt8 = 0x04
        let mode:UInt8 = UInt8(id)
        
        makeCommandAndSend(data: Data([commandId, mode]),
                           isWaitResponse: true, isWriteWithResponse: true,
                           command: GyverStateCommand.self) { (status, response) in
                            
                            callback(status, response as? GyverStateResponse)
        }
    }
    
    func changeLeds(state isOn: Bool, callback: @escaping (_ isSuccess: Bool) -> Void) {
        
        let commandId:UInt8 = 0x05
        let state:UInt8 = isOn ? 0x01 : 0x00
        
        makeCommandAndSend(data: Data([commandId, state]),
                           isWaitResponse: false, isWriteWithResponse: false,
                           command: BLECommand.self) { (status, response) in
                            
                            callback(status)
        }
    }
    
    func makeCommandAndSend<T: BLERequestInitializable>(data: Data, isWaitResponse: Bool,
                                                        isWriteWithResponse: Bool, command: T.Type,
                                                        callback: @escaping (_ isSuccessful: Bool, _ response: BLEResponse?) -> Void) {
        
        let request = GyverRequest(rawData: data, requestCharacteristic: "FFE1", responseCharacteristic: "FFE1")
        request.isWaitResponse = isWaitResponse
        request.isWriteWithResponse = isWriteWithResponse
        request.mode = .write
        request.retryCount = 0
        
        let command = command.init(with: request) as! BLECommand
        command.responseCallback = { (status, response, error) in
            dLog("status: \(status)")
            dLog("response: \(response?.dataAsString().orNil ?? "")")
            dLog("error: \(error.orNil)")
            callback(status == .success, response)
        }

        BLEManager.currentDevice?.addCommandToQueue(command)
    }
    
}


