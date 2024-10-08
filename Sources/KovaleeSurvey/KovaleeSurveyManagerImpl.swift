import Foundation
import KovaleeFramework
import KovaleeSDK
#if !targetEnvironment(macCatalyst)
    import Survicate

    class KovaleeSurveyManagerImpl: SurveyManager, Manager {
        private enum Constants {
            static let amplitudeUserIdKey = "user_id"
        }

        private var survicate: SurvicateSdk?
        weak var delegate: KovaleeSurveyDelegate?

        init(withKey workspaceKey: String?) {
            guard let workspaceKey else {
                survicate = nil
                KLogger.error("No workspaceKey found for Survicate. Survicate was not configured.")

                return
            }

            do {
                survicate = SurvicateSdk.shared
                try survicate?.setWorkspaceKey(workspaceKey)
                survicate?.initialize()
                survicate?.addListener(self)
            } catch {
                KLogger.error("Couldn't initialise Survicate: \(error)")
            }
        }

        func sendEvent(with name: String, andProperties properties: [String: Any]?) {
            if let stringOnlyProperties = properties?.compactMapValues({ $0 as? String }) {
                survicate?.invokeEvent(name: name, with: stringOnlyProperties)
            } else {
                survicate?.invokeEvent(name: name)
            }
        }

        func viewScreen(with name: String) {
            survicate?.enterScreen(value: name)
        }

        func setUserProperty(withName name: String, andValue value: String) {
            survicate?.setUserTrait(UserTrait(withName: name, value: value))
        }

        func setUserProperties(_ properties: [String: String]) {
            let traits = properties.map { UserTrait(withName: $0.key, value: $0.value) }
            survicate?.setUserTraits(traits: traits)
        }

        func setAmplitudeUserId(userId: String) {
            let amplitudeIdUserTrait = UserTrait(withName: Constants.amplitudeUserIdKey, value: userId)
            survicate?.setUserTrait(amplitudeIdUserTrait)
        }

        func setSurveyDelegate(_ delegate: KovaleeSurveyDelegate) {
            self.delegate = delegate
        }
    }

    extension KovaleeSurveyManagerImpl: SurvicateDelegate {
        func surveyDisplayed(event _: SurveyDisplayedEvent) {
            if Kovalee.getAmplitudeUserId() == nil {
                Kovalee.setAmplitudeUserId(userId: UUID().uuidString)
            }
        }

        func surveyClosed(surveyId: String) {
            delegate?.surveyClosed(surveyId: surveyId)
        }

        func surveyCompleted(event: SurveyCompletedEvent) {
            delegate?.surveyCompleted(surveyId: event.surveyId)
        }

        func surveyClosed(event: SurveyClosedEvent) {
            delegate?.surveyClosed(surveyId: event.surveyId)
        }
    }
#else

    class KovaleeSurveyManagerImpl: Manager {
        init(withKey _: String?) {}
    }
#endif
