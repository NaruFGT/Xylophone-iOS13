//
//  ViewController.swift
//  Xylophone
//
//  Created by Angela Yu on 28/06/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    var playerChannels: Array<Optional<AVAudioPlayer>>
    var notes: Array<NSDataAsset>
    
    @IBOutlet var noteKeys: [UIButton]!
    
    func populateNoteDataArray() {
        notes.append(NSDataAsset(name:"noteC")!)
        notes.append(NSDataAsset(name:"noteD")!)
        notes.append(NSDataAsset(name:"noteE")!)
        notes.append(NSDataAsset(name:"noteF")!)
        notes.append(NSDataAsset(name:"noteG")!)
        notes.append(NSDataAsset(name:"noteA")!)
        notes.append(NSDataAsset(name:"noteB")!)
    }
    
    /*
       Thank you to iOS Swift Game Development Cookbook, 2nd Edition ISBN: 9781491920800
       Chapter 4 - Sound
     */
    func playerByData(asset: NSDataAsset) -> Optional<AVAudioPlayer> {
        let availablePlayers = playerChannels.filter {
            (player) -> Bool in
            return player!.isPlaying == false && player?.data == asset.data
        }
        
        if let playerToReturn = availablePlayers.first {
            // print("Found \(availablePlayers.count) players out of \(playerChannels.count)  Reusing player \(String(describing: playerChannels.firstIndex(of: playerToReturn))) for \(asset.name)")
            return playerToReturn!
        }
        
        do {
            let newPlayer = try AVAudioPlayer(data: asset.data)
            // print("Creating new player for \(asset.name)")
            playerChannels.append(newPlayer)
            return newPlayer
        } catch let error as NSError {
            print("Could not load \(asset.name): \(String(describing: error))")
            return nil
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?){
        playerChannels = Array()
        notes = Array()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        // print("init(): nibName: \(String(describing: nibNameOrNil)) bundle: \(String(describing: nibBundleOrNil))")
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            populateNoteDataArray()
        } catch let error as NSError {
            print("Error in init(): \(error.localizedDescription)")
        }
    }

    required init?(coder unarchiver: NSCoder){
        playerChannels = Array()
        notes = Array()
        super.init(coder: unarchiver)
        // print("init(): coder: \(unarchiver)")
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            populateNoteDataArray()
        } catch let error as NSError {
            print("Error in init(): \(error.localizedDescription)")
        }
    }
    
    func fadeNote(fadeTime: DispatchTime, noteKey: UIButton) {
        print("Start") // as required by the assignment...
        for alphaValue in 0 ... 12 {
            DispatchQueue.main.asyncAfter(deadline: fadeTime + Double(alphaValue)/24+0.2) {
                //print("\(noteKey.titleLabel!.text!) key alpha: \(Double(alphaValue)/24+0.5)")
                noteKey.alpha = CGFloat(alphaValue)/24+0.5
            }
            DispatchQueue.main.asyncAfter(deadline: fadeTime) {
                noteKey.alpha = 0.5
            }
        }
        DispatchQueue.main.asyncAfter(deadline: fadeTime + 0.2) {
            print("End") // as required by the assignment...
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Check noteKeys indices
        for noteKey in noteKeys {
            print("noteKey.tag: \(noteKey.tag) noteKey.titleLabel.text: \(String(describing: noteKey.titleLabel!.text))")
        }
        */
    }
    
    @IBAction func keyPressed(_ sender: UIButton, forEvent event: UIEvent) {
        let player = playerByData(asset: notes[sender.tag])
        // print("sender.tag: \(sender.tag)")
        // print(noteKeys[sender.tag].titleLabel!.text!)
        fadeNote(fadeTime: .now(), noteKey: noteKeys[sender.tag])
        player?.play()
    }
}

