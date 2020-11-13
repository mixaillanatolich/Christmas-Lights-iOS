//
//  LedControlManager.swift
//  Christmas Lights
//
//  Created by Mixaill on 08.11.2020.
//  Copyright © 2020 M-Technologies. All rights reserved.
//

import UIKit


let LEDController = LedControlManager.sharedInstance

enum LedSolidColors: UInt32 {
    case black = 0x20
    case red = 0x21
    case orange = 0x22
    case yellow = 0x23
    case green = 0x24
    case skyblue = 0x25
    case blue = 0x26
    case violet = 0x27
    case white = 0x28
}

class LedControlManager: NSObject {
    
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
    
    func setMode(_ id: Int, callback: @escaping (_ isSuccessful: Bool) -> Void) {
        let commandId:UInt8 = 0x03
        let modeId:UInt8 = UInt8(id)
        makeCommandAndSend(data: Data([commandId, modeId]),
                           isWaitResponse: true, isWriteWithResponse: true,
                           command: SetModeCommand.self) { (status, response) in
                            callback(status)
        }
    }
    
    //MARK: - brightness
    func brightnessPlusCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x01, callback: callback)
    }
    
    func brightnessMinusCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x02, callback: callback)
    }
    
    //MARK: -
    func resetCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x03, callback: callback)
    }
    
    func randomCmd(random: Bool, callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(random ? 0x05 : 0x04, callback: callback)
    }
    
    func stopCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x19, callback: callback)
    }
    
    //MARK: - led count
    func ledPlusCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x08, callback: callback)
    }
    
    func ledMinusCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x09, callback: callback)
    }
    
    //MARK: -
    func changeEffectDirectionCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x0a, callback: callback)
    }
    
    func speedMinusCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x0b, callback: callback)
    }
    
    func speedPlusCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x0c, callback: callback)
    }
    
    //MARK: -
    func glitterCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x0d, callback: callback)
    }
    
    func backgroudCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x0e, callback: callback)
    }
    
    func candleCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x0f, callback: callback)
    }
    
    //MARK: -
    func prevModeCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x10, callback: callback)
    }
    
    func nextModeCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x11, callback: callback)
    }
    
    //MARK: -
    func delayMinusCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x13, callback: callback)
    }
    
    func delayPlusCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x14, callback: callback)
    }
    
    //MARK: - Palette
    func paletteStopCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x15, callback: callback)
    }
    
    func palettePreviousCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x16, callback: callback)
    }
    
    func paletteNextCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x17, callback: callback)
    }
    
    func paletteAutoCmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(0x18, callback: callback)
    }
    
    //MARK: - colors
    func setColorCmd(_ color: LedSolidColors, callback: @escaping (_ isSuccessful: Bool) -> Void) {
        sendCommand(color.rawValue, callback: callback)
    }
    
//    //MARK: -
//    func Cmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
//        sendCommand(0x, callback: callback)
//    }
//
//    func Cmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
//        sendCommand(0x, callback: callback)
//    }
//
//    func Cmd(callback: @escaping (_ isSuccessful: Bool) -> Void) {
//        sendCommand(0x, callback: callback)
//    }
    
    fileprivate func sendCommand(_ command: UInt32, callback: @escaping (_ isSuccessful: Bool) -> Void) {
        let commandId:UInt8 = 0x02
        
        var commandData = Data()
        commandData.append(Data([commandId]))
        commandData.append(Data([ UInt8(command & 0x000000FF) ]))
//        commandData.append(Data([
//            UInt8(command & 0x000000FF),
//            UInt8((command & 0x0000FF00) >> 8),
//            UInt8((command & 0x00FF0000) >> 16),
//            UInt8((command & 0xFF000000) >> 24)
//            ]))
        
        makeCommandAndSend(data: commandData,
                           isWaitResponse: true, isWriteWithResponse: true,
                           command: SetModeCommand.self) { (status, response) in
                            callback(status)
        }
    }
    
    func makeCommandAndSend<T: BLERequestInitializable>(data: Data, isWaitResponse: Bool,
                                                        isWriteWithResponse: Bool, command: T.Type,
                                                        callback: @escaping (_ isSuccessful: Bool, _ response: BLEResponse?) -> Void) {
        
        let request = CommonRequest(rawData: data, requestCharacteristic: "FFE1", responseCharacteristic: "FFE1")
        request.timeout = 2
        request.isWaitResponse = isWaitResponse
        request.isWriteWithResponse = isWriteWithResponse
        request.mode = .write
        request.retryCount = 1
        
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


