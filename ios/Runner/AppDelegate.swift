import UIKit
import Flutter
import YandexMapKit
import Firebase
import FirebaseCore
import Speech
import AVKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    let speechRecognizer        = SFSpeechRecognizer(locale: Locale(identifier: "ru-RU"))
    var recognitionRequest      : SFSpeechAudioBufferRecognitionRequest?
    let audioEngine             = AVAudioEngine()
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    YMKMapKit.setApiKey("c2270c63-ab7b-463b-b6d7-20821d098826")
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let voiceChannel = FlutterMethodChannel(name: "flutter/MethodChannelDemoExam",
                                                  binaryMessenger: controller.binaryMessenger)
    
    
    
    
    
    
    
    
    voiceChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
    
        switch call.method {
                case "start":
                    let audioSession = AVAudioSession.sharedInstance()
                    do {
                        try audioSession.setCategory(AVAudioSession.Category.record, mode: AVAudioSession.Mode.measurement, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
                    } catch {
                        print("audioSession properties weren't set because of an error.")
                    }

                    self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

                    let inputNode = self.audioEngine.inputNode

                    guard let recognitionRequest = self.recognitionRequest else {
                        fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
                    }

                    recognitionRequest.shouldReportPartialResults = true

                   // self.recognitionTask =
                    self.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (resultText, error) in

                        var isFinal = false

                        if resultText != nil {
                            result(resultText?.bestTranscription.formattedString)
                        
                            isFinal = (resultText?.isFinal)!
                
                        }
                        if error != nil || isFinal {
                            
                            self.audioEngine.stop()
                            inputNode.removeTap(onBus: 0)
                            self.recognitionRequest = nil
                            //self.btnStart.isEnabled = true
                        }
                    })

                    let recordingFormat = inputNode.outputFormat(forBus: 0)
                    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
                        self.recognitionRequest?.append(buffer)
                    }

                    self.audioEngine.prepare()

                    do {
                        try self.audioEngine.start()
                    } catch {
                        print("audioEngine couldn't start because of an error.")
                    }
                   // self.receiveVoiceText(returnFlutter: result)
                case "stop":
                    self.audioEngine.stop()
                    self.recognitionRequest?.endAudio()
                default:
                    result(FlutterMethodNotImplemented)
                }
        
        
        })
    
    
    
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    private func  receiveVoiceText(returnFlutter: FlutterResult){
    
       
    }
    
}
