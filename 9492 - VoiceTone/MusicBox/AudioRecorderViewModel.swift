import Foundation
import AVFoundation
import Combine

class AudioRecorderViewModel: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var recordedURL: URL?
    @Published var hasPermission = false
    
    private var audioRecorder: AVAudioRecorder?
    
    override init() {
        super.init()
        checkPermission()
    }
    
    func checkPermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                self.hasPermission = granted
            }
        }
    }
    
    func startRecording() {
        guard hasPermission else { return }

        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.playAndRecord, mode: .default)
        try? session.setActive(true)
        
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        guard let recorder = try? AVAudioRecorder(url: url, settings: settings) else { return }
        audioRecorder = recorder
        recorder.record()
        isRecording = true
        recordedURL = url
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
}
