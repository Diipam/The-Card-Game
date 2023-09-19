//
//  soundManager.swift
//  TheCardGame
//
//  Created by Smart Solar Nepal on 19/09/2023.
//

import Foundation
import AVFoundation

class soundManager {

    var audioplayer: AVAudioPlayer?

    enum soundEffect {
        case shuffle
        case noMatch
        case matched
        case flip
    }

    func playSound(effect: soundEffect) {

      var soundFileName = ""

            switch effect {
            case .flip:
                soundFileName = "cardflip"

            case .matched:
                soundFileName = "dingcorrect"

            case.noMatch:
                soundFileName = "dingwrong"

            case.shuffle:
                soundFileName = "shuffle"

            }

//        Get the path to the sound resource file
//        inorder to get to a source file that maybe sound audio or video we normally use bundle inorder to do so

       let bundlePath =  Bundle.main.path(forResource: soundFileName, ofType: ".wav")

// guards and checks if bundle
        guard bundlePath != nil else {
            return
        }

        let url = URL(fileURLWithPath: bundlePath!)

        do {
            
// Create the audio player
            audioplayer = try AVAudioPlayer(contentsOf: url)

//            Play the sound effect
            audioplayer?.play()

        } catch {
            print("Error couldn't load sound")
            return
        }
    }

}
