// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/AudioKit/

import AudioKit
import XCTest

class SmoothDelayTests: XCTestCase {

    func testDefault() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKOperationEffect(input) { $0.smoothDelay() }
        input.start()
        let audio = engine.startTest(totalDuration: 4.0)
        audio.append(engine.render(duration: 4.0))
        testMD5(audio)
    }

    func testFeedback() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKOperationEffect(input) { $0.smoothDelay(feedback: 0.66) }
        input.start()
        let audio = engine.startTest(totalDuration: 4.0)
        audio.append(engine.render(duration: 4.0))
        testMD5(audio)
    }

    func testParameters() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKOperationEffect(input) { $0.smoothDelay(time: 0.05, feedback: 0.66, samples: 256) }
        input.start()
        let audio = engine.startTest(totalDuration: 4.0)
        audio.append(engine.render(duration: 4.0))
        testMD5(audio)
    }

    func testParameterSweep() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKOperationEffect(input) { input in
            let ramp = AKOperation.lineSegment(
                trigger: AKOperation.metronome(frequency: 1.0),
                start: 0.0,
                end: 0.1,
                duration: 4.0)
            return input.smoothDelay(time: 0.01 + ramp, feedback: 0.99 - ramp, samples: 512)
        }
        input.start()
        let audio = engine.startTest(totalDuration: 4.0)
        audio.append(engine.render(duration: 4.0))
        testMD5(audio)
    }

    func testTime() {
        let engine = AKEngine()
        let input = AKOscillator()
        engine.output = AKOperationEffect(input) { $0.smoothDelay(time: 0.05) }
        input.start()
        let audio = engine.startTest(totalDuration: 4.0)
        audio.append(engine.render(duration: 4.0))
        testMD5(audio)
    }

}
