import Foundation

/// User-facing strings. Wellness wording lives here so tests can audit it.
enum Copy {
    static let appName = "TugCheck"
    static let defaultPersonName = "Me"

    static let startATugCheck = "Start a TugCheck"
    static let people = "People"
    static let about = "About"
    static let history = "History"
    static let close = "Close"
    static let cancel = "Cancel"
    static let save = "Save"
    static let done = "Done"
    static let delete = "Delete"
    static let addPerson = "Add a person"
    static let editPerson = "Edit person"
    static let name = "Name"
    static let birthYear = "Birth year"
    static let includeBirthYear = "Include birth year"
    static let seconds = "seconds"
    static let date = "Date"
    static let note = "Note"
    static let observations = "Observations"
    static let share = "Share"
    static let start = "Start"
    static let stop = "Stop"
    static let go = "Go"
    static let retake = "Retake"
    static let discard = "Discard"

    static let homeExplanation = "TugCheck times the Timed Up & Go walk: stand up, walk 3 m (10 ft), turn, walk back, and sit down. Use it to track your mobility and share results with your doctor."
    static let helperHoldsPhone = "A helper holds the phone and runs the timer. The person being tested does not hold it."
    static let emptyPeople = "No one is listed yet. Add a person to track your mobility. A helper holds the phone during the walk."
    static let noResultsYet = "No results yet"
    static let managePeopleHint = "Add, edit, or delete people"
    static let historyHint = "Shows results for this person"
    static let storedLocally = "People and results stay on this iPhone."

    static let safetyTitle = "Safety and setup"
    static let person = "Person"
    static let walkingAidUsed = "Walking aid used"
    static let helperConfirms = "The helper confirms each item before the timed test."
    static let checkChair = "Sturdy chair with arms, placed against a wall. Seat height about 44–47 cm (17–18 in). Use the same chair every time. Chair type affects the time."
    static let checkPath = "Clear 3 m (10 ft) path, with the end marked."
    static let checkShoes = "Normal shoes, and the usual walking aid if the person uses one."
    static let checkHelper = "The helper stays close and is ready to assist."
    static let readAloudTitle = "Read aloud"
    static let readAloud = "Sit back in the chair. On \"Go\", stand up, walk to the mark at a comfortable pace, turn, walk back, and sit down."
    static let tickEveryItem = "Tick every item before starting."
    static let startHint = "Starts the next step for this person"
    static let untickedHint = "Not ticked. Required before the timed test."
    static let tickedHint = "Ticked."
    static let addPersonBeforeStart = "Add a person before starting."

    static let backToSetup = "Back to setup"
    static let practiceTitle = "Practice"
    static let practiceIntro = "Do one practice walk before the first timed attempt. This practice is not timed."
    static let startPractice = "Start practice"
    static let doneStartTimed = "Done — start the timed test"
    static let nextStep = "Next step"
    static let practiceReady = "When the practice walk is finished, start the timed test."

    static let practiceSteps: [String] = [
        "Sit back in the chair.",
        "On \"Go\", stand up.",
        "Walk to the mark at a comfortable pace.",
        "Turn.",
        "Walk back.",
        "Sit all the way down."
    ]

    static let getReady = "Get ready"
    static let stopWhenSeated = "Stop when the person is fully seated."
    static let cancelAttempt = "Cancel"
    static let discardAttemptHint = "Discards this attempt"
    static let elapsedTime = "Elapsed time"
    static let countdown = "Countdown"

    static let resultTitle = "Result"
    static let cdcReference = "CDC STEADI uses 12 seconds as a reference point. Cut-offs differ by group, so the trend over time matters more than one result. This is not a diagnosis. Share your results with your doctor."
    static let cutOffNote = "Twelve seconds is a reference point only. Cut-offs differ by group: about 13.5 seconds for community-dwelling older adults and about 11.5 seconds for people with Parkinson's. The trend over time matters most."
    static let optionalNote = "Optional note"
    static let observationsHelp = "Optional. Tap any that the helper noticed."
    static let couldNotSave = "Could not save this result. Please try again."
    static let couldNotSavePerson = "Could not save this person. Please try again."
    static let retakeHint = "Discards this result and returns to the countdown"
    static let discardHint = "Discards this result without saving"
    static let saveHint = "Saves this result on this iPhone"

    static let walkingAidYes = "Walking aid: Yes"
    static let walkingAidNo = "Walking aid: No"
    static let cdcReferenceLabel = "CDC reference"
    static let deleteResult = "Delete result"
    static let chartNeedsMore = "A chart appears after two or more results. The trend over time matters most."
    static let chartLabel = "Times over time. The dashed line at 12 seconds is the CDC reference."
    static let shareHint = "Shares a plain-text summary"
    static let shareNeedsResult = "Save a result before sharing."

    static let deletePersonTitle = "Delete this person?"
    static let deletePersonMessage = "Their saved results will be deleted too. This cannot be undone."
    static let deletePersonHint = "Deletes this person and their results after you confirm"

    static let aboutDisclaimer = "TugCheck is a wellness tool and does not diagnose or treat any condition. Stop the test if the person feels dizzy, pain, or short of breath, and always have someone nearby."
    static let aboutLocal = "Results stay on this iPhone. TugCheck has no account and does not use the network, except when you open the links below in Safari."
    static let aboutPurpose = "TugCheck helps a helper time the Timed Up & Go walk so you can track your mobility and share results with your doctor."
    static let cdcLink = "CDC STEADI"
    static let physioLink = "Physiopedia Timed Up and Go"
    static let opensInSafari = "Opens in Safari"
    static let shareIntro = "Track your mobility. Share with your doctor."

    static func practiceProgress(current: Int, total: Int) -> String {
        "Step \(current) of \(total)"
    }

    static func yesNo(_ value: Bool) -> String {
        value ? "Yes" : "No"
    }

    /// Every fixed phrase shown in the interface, for the wording audit.
    static var auditedUserFacingText: [String] {
        [
            appName,
            defaultPersonName,
            startATugCheck,
            people,
            about,
            history,
            close,
            cancel,
            save,
            done,
            delete,
            addPerson,
            editPerson,
            name,
            birthYear,
            includeBirthYear,
            seconds,
            date,
            note,
            observations,
            share,
            start,
            stop,
            go,
            retake,
            discard,
            homeExplanation,
            helperHoldsPhone,
            emptyPeople,
            noResultsYet,
            managePeopleHint,
            historyHint,
            storedLocally,
            safetyTitle,
            person,
            walkingAidUsed,
            helperConfirms,
            checkChair,
            checkPath,
            checkShoes,
            checkHelper,
            readAloudTitle,
            readAloud,
            tickEveryItem,
            startHint,
            untickedHint,
            tickedHint,
            addPersonBeforeStart,
            backToSetup,
            practiceTitle,
            practiceIntro,
            startPractice,
            doneStartTimed,
            nextStep,
            practiceReady,
            getReady,
            stopWhenSeated,
            cancelAttempt,
            discardAttemptHint,
            elapsedTime,
            countdown,
            resultTitle,
            cdcReference,
            cutOffNote,
            optionalNote,
            observationsHelp,
            couldNotSave,
            couldNotSavePerson,
            retakeHint,
            discardHint,
            saveHint,
            walkingAidYes,
            walkingAidNo,
            cdcReferenceLabel,
            deleteResult,
            chartNeedsMore,
            chartLabel,
            shareHint,
            shareNeedsResult,
            deletePersonTitle,
            deletePersonMessage,
            deletePersonHint,
            aboutDisclaimer,
            aboutLocal,
            aboutPurpose,
            cdcLink,
            physioLink,
            opensInSafari,
            shareIntro,
            practiceProgress(current: 1, total: practiceSteps.count),
            yesNo(true),
            yesNo(false)
        ] + practiceSteps + MobilityObservation.allCases.map(\.label)
    }
}
