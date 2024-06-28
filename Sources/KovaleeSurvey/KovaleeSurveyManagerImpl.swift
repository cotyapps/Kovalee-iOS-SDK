import Survicate
import KovaleeSDK
import Foundation
import KovaleeFramework

class KovaleeSurveyManagerImpl: SurveyManager, Manager {
    
    private let survicate: SurvicateSdk?

    init(withKey workspaceKey: String?) {

        guard let workspaceKey else {
            self.survicate = nil
            KLogger.error("No workspaceKey found for Survicate. Survicate was not configured.")
            
            return
        }

        do {
            self.survicate = SurvicateSdk.shared
            try self.survicate?.setWorkspaceKey(workspaceKey)
            self.survicate?.initialize()
            self.survicate?.addListener(self)
        } catch {
            KLogger.error("Couldn't initialise Survicate: \(error)")
        }
    }

    func sendEvent(with name: String, andProperties properies: [String : String]) {
        survicate?.invokeEvent(name: name, with: properies)
    }

    func viewScreen(with name: String) {
        survicate?.enterScreen(value: name)
    }

    func setUserProperty(withName name: String, andValue value: String) {
        let userTrait = UserTrait(withName: name, value: value)
        survicate?.setUserTrait(userTrait)
    }
}

// TODO: - Implement methods if needed (and remove unused)
extension KovaleeSurveyManagerImpl: SurvicateDelegate {
    func surveyClosed(surveyId: String) {}
    func surveyDisplayed(event: SurveyDisplayedEvent) {}
    func questionAnswered(_ event: QuestionAnsweredEvent) {}
    func surveyCompleted(event: SurveyCompletedEvent) {}
    func surveyClosed(event: SurveyClosedEvent) {}
}
