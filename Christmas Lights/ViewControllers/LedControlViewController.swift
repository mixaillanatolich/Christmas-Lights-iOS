//
//  LedControlViewController.swift
//  Christmas Lights
//
//  Created by Mixaill on 08.11.2020.
//  Copyright © 2020 M-Technologies. All rights reserved.
//

import UIKit
import CoreBluetooth

public protocol LedControlScreenDelegate : NSObjectProtocol {
    func pairControllerWillDismiss()
}

class LedControlViewController: BaseViewController {

    @IBOutlet weak var pairButton: UIButton!
    @IBOutlet weak var controlLabel: UILabel!
    @IBOutlet weak var effectsTable: UITableView!
    
    @IBOutlet weak var showMoreOptionsButton: UIButton!
    @IBOutlet weak var controlViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var controlViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var brightnessPlus: UIButton!
    @IBOutlet weak var brightnessMinus: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var shuffleButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var ledPlusButton: UIButton!
    @IBOutlet weak var ledMinusButton: UIButton!
    @IBOutlet weak var changeEffectDirectionButton: UIButton!
    @IBOutlet weak var speedMinusButton: UIButton!
    @IBOutlet weak var speedPlusButton: UIButton!
    @IBOutlet weak var glitterButton: UIButton!
    @IBOutlet weak var backgroudButton: UIButton!
    @IBOutlet weak var candleButton: UIButton!
    @IBOutlet weak var prevEffectButton: UIButton!
    @IBOutlet weak var nextEffectButton: UIButton!
    @IBOutlet weak var delayMinusButton: UIButton!
    @IBOutlet weak var delayPlusButton: UIButton!
    @IBOutlet weak var paletteStopButton: UIButton!
    @IBOutlet weak var palettePreviousButton: UIButton!
    @IBOutlet weak var paletteNextButton: UIButton!
    @IBOutlet weak var paletteAutoButton: UIButton!
    
    
    @UserDefaultOptionl<String>(key: .deviceId, defaultValue: nil) var deviceId
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LEDController.settingsallback = { (settings) in
            self.parseSettings(settings)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        screenDidShow()
    }
    
    fileprivate func parseSettings(_ response: LightsStateResponse) {

        dLog("\n\tsettings \n\teffectId: \(response.effectId) \n\tledMode: \(response.ledMode.rawValue) \n\tglitterEnabled: \(response.glitterEnabled) \n\tcandleEnabled: \(response.candleEnabled) \n\tbackgroudEnabled: \(response.candleEnabled)")
        
        stopButton.isSelected = response.ledMode == .off
        shuffleButton.isSelected = response.ledMode == .allShuffle || response.ledMode == .userShuffle
        
        if response.effectId < effects.count {
            effectsTable.selectRow(at: IndexPath(row: response.effectId, section: 0), animated: true, scrollPosition: .middle)
        }
        
        glitterButton.isSelected = response.glitterEnabled
        candleButton.isSelected = response.candleEnabled
        backgroudButton.isSelected = response.backgroudEnabled
    }
    
    //MARK: -
    @IBAction func pairButtonClicked(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowPairScreen", sender: {(destVC: UIViewController) in
            destVC.presentationController?.delegate = self
        } as SegueSenderCallback)
    }
    
    @IBAction func buttonClicked(_ sender: Any) {
//            LEDController.sendPing { (success) in
//                dLog("send ping res: \(success)")
//            }
            
        LEDController.loadSetting(callback: { (result, response) in
            if result {
                self.parseSettings(response!)
            }
        })
    }
    
    @IBAction func showMoreOptionsButtonClicked(_ sender: Any) {
        showMoreOptionsButton.isSelected = !showMoreOptionsButton.isSelected
        showMoreOptionsButton.isUserInteractionEnabled = false
        controlViewHeightConstraint.constant = showMoreOptionsButton.isSelected ? 385.0 : 210.0
        UIView.animate(withDuration: 0.8, animations: {
                self.view.layoutIfNeeded()
            }, completion: {res in
                self.showMoreOptionsButton.isUserInteractionEnabled = true
        })
    }
    
    // MARK: - control commands
    
    @IBAction func brightnessPlusButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.brightnessPlusCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func brightnessMinusButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.brightnessMinusCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func resetButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.resetCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func shuffleButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        LEDController.randomCmd(random: sender.isSelected) { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func stopButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.isEnabled = false
        if sender.isSelected {
            LEDController.stopCmd { (status) in
                DispatchQueue.main.async {
                    sender.isEnabled = true
                }
            }
        } else {
            LEDController.randomCmd (random: shuffleButton.isSelected) { (status) in
                DispatchQueue.main.async {
                    sender.isEnabled = true
                }
            }
        }
        
    }
    
    @IBAction func ledPlusButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.ledPlusCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func ledMinusButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.ledMinusCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func ButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.resetCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func changeEffectDirectionButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.changeEffectDirectionCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func speedMinusButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.speedMinusCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func speedPlusButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.speedPlusCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func glitterButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.glitterCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func backgroudButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.backgroudCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func candleButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.candleCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func prevEffectButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.prevModeCmd { (status) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func nextEffectButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.nextModeCmd { (status) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func delayMinusButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.delayMinusCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func delayPlusButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.delayPlusCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func paletteStopButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.paletteStopCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func palettePreviousButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.palettePreviousCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func paletteNextButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.paletteNextCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    @IBAction func paletteAutoButtonClicked(_ sender: UIButton) {
        sender.isEnabled = false
        LEDController.paletteAutoCmd { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    // tags 32 - 40
    @IBAction func changeColorButtonClicked(_ sender: UIButton) {
        guard let ledColor = LedSolidColors(rawValue: UInt32(sender.tag)) else {return}
        sender.isEnabled = false
        LEDController.setColorCmd(ledColor) { (status) in
            DispatchQueue.main.async {
                sender.isEnabled = true
            }
        }
    }
    
    
    //MARK: -
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension LedControlViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        DispatchQueue.main.async {
            self.screenDidShow()
        }
    }
}

extension LedControlViewController: LedControlScreenDelegate {
    func pairControllerWillDismiss() {
        DispatchQueue.main.async {
            self.screenDidShow()
        }
    }
}

extension LedControlViewController {
    
    fileprivate func screenDidShow() {
        
        BLEManager.setupConnectStatusCallback { (connectStatus, peripheral, devType, error) in
            
            dLog("conn status: \(connectStatus)")
            dLog("error: \(error.orNil)")
            
            if connectStatus == .ready {
                DispatchQueue.main.async {
                    self.controlLabel.textColor = UIColor.green
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.buttonClicked(self)
                }
            } else if connectStatus == .error || connectStatus == .timeoutError || connectStatus == .disconected {
                DispatchQueue.main.async {
                    self.controlLabel.textColor = UIColor.yellow
                    BLEManager.connectToDevice(peripheral!, deviceType: .expectedDevice,
                                               serviceIds: [CBUUID(string: "FFE0")],
                                               characteristicIds: [CBUUID(string: "FFE1")], timeout: 30.0)
                }
            }
        }
          
        self.controlLabel.textColor = UIColor.white
        
        guard !BLEManager.deviceConnected() else {
            self.controlLabel.textColor = UIColor.green
//            self.loadSettings()
            return
        }
          
        guard let deviceId = deviceId else {
            return
        }
        
        guard let peripheral = BLEManager.canConnectToPeripheral(with: deviceId) else {
            return
        }
        
        self.controlLabel.textColor = UIColor.yellow
        BLEManager.connectToDevice(peripheral, deviceType: .expectedDevice,
                                   serviceIds: [CBUUID(string: "FFE0")],
                                   characteristicIds: [CBUUID(string: "FFE1")],
                                   device: LedDevicePeripheral.self, timeout: 30.0)
    }
    
}

fileprivate let effects = ["Blendwave",
                           "Rainbow beat",
                           "Two sin",
                           "One sin palette",
                           "Noise8 palette",
                           "Two sin 2",
                           "One sin palette 2",
                           "Juggle palette",
                           "Matrix palette",
                           "Two sin 3",
                           "One sin palette 3",
                           "Three sin palette",
                           "Serendipitous palette",
                           "One sin palette 4",
                           "Two sin 4",
                           "Matrix palette 2",
                           "Noise8 palette 2",
                           "Plasma",
                           "Two sin 5",
                           "Rainbow march",
                           "Three sin palette 2",
                           "Rainbow march 2",
                           "Noise16 palette",
                           "One sin palette 5",
                           "Plasma 2",
                           "Confetti palette",
                           "Two sin 6",
                           "Matrix palette 3",
                           "One sin palette 6",
                           "Confetti palette 2",
                           "Plasma 3",
                           "Juggle palette 2",
                           "One sin palette 7",
                           "Three sin palette 3",
                           "Rainbow march 3",
                           "Plasma 4",
                           "Confetti palette 3",
                           "Noise16 palette 2",
                           "Noise8 palette 3",
                           "Fire",
                           "Candles",
                           "Colorwaves"]

extension LedControlViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return effects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        cell.textLabel?.textColor = UIColor.white
        cell.textLabel?.text = effects[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LEDController.setMode(indexPath.row) { (res) in
            if !res {
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}
