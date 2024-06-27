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
        // TODO: - implement
    }

    func viewScreen(with name: String) {
        // TODO: - implement
    }

    func setUserProperies(properties: [String : String]) {
        // TODO: - implement
    }

    func setUserProperty(withName name: String, andValue value: String) {
        // TODO: - implement
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
