//
//  ViewController.swift
//  altertune-proto
//
//  Created by Weinstein, Randy - Nick.com on 5/8/17.
//  Copyright © 2017 com.fakeancient. All rights reserved.
//

import UIKit
import AudioKit

enum playState {
    case playing
    case stopped
}

enum PlayMode:Int {
    case plucked
    case droning
    case grooving
}

class ViewController: UIViewController {
    
    var thePlayState = playState.stopped
    var generator:AKOperationGenerator?

    
    var euroTones =  [1.0,9.0/8.0,5.0/4.0,4.0/3.0,3.0/2.0,5.0/3.0,15.0/8.0,2.0/1.0]
    var ancientGreekTones = [1.0, 32.0/31.0, 16.0/15.0, 4.0/3.0, 3.0/2.0, 48.0/31.0, 8.0/5.0,2.0/1.0]
    let pluckedString = AKPluckedString()
    var euroTonesDisplay =  ["1/1","9/8","5/4","4/3","3/2","5/3","15/8","2/1"]
    var ancientGreekTonesDisplay = ["1/1", "32/31", "16/15","4/3", "3/2", "48/31", "8/5","2/1"]

    
    var scaleTones:[Double] = []
    var selectedToneButtons = [UIButton]()
    var theOrchestra = [AKOperation]()
    var baseFrequency = 110
    var baseMetronome = -1.0
    
    func instrument(noteIdentity: Double, rate: Double, amplitude: Double) -> AKOperation {
        
        let metro = AKOperation.metronome(frequency:rate )
        
        let frequency = noteIdentity
        
        return AKOperation.pluckedString(trigger: metro,frequency:frequency)
        
        /*return AKOperation.fmOscillator(
         baseFrequency: frequency,
         //carrierMultiplier:1.0,
         //modulatingMultiplier:2,
         //modulationIndex:2.0,
         amplitude: amplitude)
         .triggeredWithEnvelope(trigger: metro, attack: 0.0, hold: 0.2 , release: 0.2)
         */
    }
    
    func startTheSystem() {
        
        generator = AKOperationGenerator() { _ in
            
            var instruments:AKOperation?
            
            for currentInstrument in theOrchestra {
                
                if let _ = instruments {
                    instruments = instruments! + currentInstrument
                } else {
                    instruments = currentInstrument
                }
            }
            
            
            instruments = instruments! * 0.80
            
            let reverb = instruments?.reverberateWithCostello(feedback: 0.6, cutoffFrequency: 20000).toMono()
            
            return mixer(instruments!, reverb!, balance:0.0 )
            
        }
        
        if let theGenerator = generator {
            AudioKit.stop()
            AudioKit.output = generator
            AudioKit.start()
            theGenerator.start()
        }
        
    }
    
    func stopTheSystem() {
        
        AudioKit.stop()
        
        if let theGenerator = generator {
            theGenerator.stop()
            theOrchestra = []
        }
        
        for currentButton in selectedToneButtons {
            currentButton.backgroundColor = UIColor.lightGray
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scaleTones = euroTones
        for case let button as UIButton in self.view.subviews {
            if button.tag >= 1 && button.tag <= 8 {
                let currentTitle = "\(euroTonesDisplay[button.tag - 1])"
                button.setTitle(currentTitle,for: .normal)
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    @IBAction func selectPlayMode(_ sender: UISegmentedControl) {
        //let playMode = sender.selectedSegmentIndex
        
        if let newPlayMode = PlayMode(rawValue:sender.selectedSegmentIndex) {
            
            switch newPlayMode {
            case .plucked:
                baseMetronome = -1.0
            case .droning:
                baseMetronome = 0.0
            case .grooving:
                baseMetronome = 1.0
            }
            
        }
        
        
    }
    
    @IBAction func toggleNote(_ sender: UIButton) {
        print(scaleTones[sender.tag - 1])
        
        if ( baseMetronome == -1.0) {
            
            AudioKit.output = pluckedString
            AudioKit.start()
            pluckedString.trigger(frequency: 200 * scaleTones[sender.tag - 1])
            
        } else {
            
            sender.backgroundColor = UIColor.green
            selectedToneButtons.append(sender)
            let theRatio = scaleTones[sender.tag - 1]
            
            let theTone = theRatio  * baseFrequency
            var theBeat = baseMetronome * theRatio
            
            if theBeat == 0 {
                theBeat = 0.2
            }
            
            let theInstrument = instrument(noteIdentity: theTone, rate: theBeat, amplitude: 0.5)
            theOrchestra.append(theInstrument)

            
        }
    }
    
    @IBAction func changeScale(_ sender: UIButton) {
        
        if sender.titleLabel?.text == "European" {
            sender.setTitle("Ancient", for:.normal)
            scaleTones = ancientGreekTones
            for case let button as UIButton in self.view.subviews {
                if button.tag >= 1 && button.tag <= 8 {
                    let currentTitle = "\(ancientGreekTonesDisplay[button.tag - 1])"
                    button.setTitle(currentTitle,for: .normal)
                }
            }
        } else {
            sender.setTitle("European", for:.normal)
            scaleTones = euroTones
            for case let button as UIButton in self.view.subviews {
                if button.tag >= 1 && button.tag <= 8 {
                    let currentTitle = "\(euroTonesDisplay[button.tag - 1])"
                    button.setTitle(currentTitle,for: .normal)
                }
            }
        }
    }
    
   
    @IBAction func play(_ sender: Any) {
        
        let theButton:UIButton = sender as! UIButton
        var newButtonTitle:String
        
        switch thePlayState {
        case .stopped:
            if theOrchestra.count > 0 {
                startTheSystem()
                thePlayState = .playing
                newButtonTitle = "Stop"
            } else {
                newButtonTitle = "Listen"
            }
        case .playing:
            stopTheSystem()
            thePlayState = .stopped
            newButtonTitle = "Listen"
        }
        
        theButton.setTitle(newButtonTitle, for: .normal)

    }
    
    

}

