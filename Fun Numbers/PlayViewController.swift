//
//  PlayViewController.swift
//  Fun Numbers
//
//  Created by Thobio on 01/10/18.
//  Copyright © 2018 Zerone Consulting. All rights reserved.
//

import UIKit
import Speech

class PlayViewController: UIViewController {
    
    @IBOutlet var lbl_Number: UILabel!
    let audioEngine = AVAudioEngine()
    let speechRecongnizer:SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recogmitionTask: SFSpeechRecognitionTask?
    var node : AVAudioInputNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recordAndRecognizeSpeech()
    }
    func recordAndRecognizeSpeech(){
        node = audioEngine.inputNode
        let recordingFormat = node?.outputFormat(forBus: 0)
        node?.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){ buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }catch{
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        if !myRecognizer.isAvailable {
            return
        }
        recogmitionTask = speechRecongnizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result {
                let bestString = result.bestTranscription.formattedString
                self.lbl_Number.text = bestString
            }else if let error = error {
                print(error)
            }
        })
    }
}
