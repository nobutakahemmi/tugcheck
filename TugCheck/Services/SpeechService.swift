import AVFoundation
import Foundation

/// Speaks the "Go" cue. The timer starts when speech actually begins.
final class SpeechService: NSObject, AVSpeechSynthesizerDelegate {
    private let synthesizer = AVSpeechSynthesizer()
    var onSpeakStarted: ((String) -> Void)?

    override init() {
        super.init()
        synthesizer.delegate = self
    }

    func speak(_ text: String) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try session.setActive(true)
        } catch {
            // The cue is still spoken if the audio session cannot be changed.
        }

        let utterance = AVSpeechUtterance(string: text)
        if let voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode()) {
            utterance.voice = voice
        }
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        synthesizer.stopSpeaking(at: .immediate)
        synthesizer.speak(utterance)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
        } catch {
            // The session can stay active if another sound is using it.
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        _ = synthesizer
        let text = utterance.speechString
        DispatchQueue.main.async { [weak self] in
            self?.onSpeakStarted?(text)
        }
    }
}
