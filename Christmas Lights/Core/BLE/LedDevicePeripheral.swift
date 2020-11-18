//
//  LedDevicePeripheral.swift
//  Christmas-Lights
//
//  Created by Mixaill on 16.11.2020.
//  Copyright © 2020 M-Technologies. All rights reserved.
//

import Foundation
import CoreBluetooth

class LedDevicePeripheral: BLEDevicePeripheral {
    required init(initWith cbPeripheral: CBPeripheral, serviceIds: [CBUUID], characteristicIds: [CBUUID], responseFactory: BLEResponseFactory? = nil) {
        super.init(initWith: cbPeripheral, serviceIds: serviceIds, characteristicIds: characteristicIds, responseFactory:ResponseFactory())
    }
}
