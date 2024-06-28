import Survicate
import KovaleeSDK
import Foundation
import KovaleeFramework

class KovaleeSurveyManagerImpl: SurveyManager, Manager {

    private enum Constants {
        static let amplitudeUserIdKey = "user_id"
        static let pageViewEventNamePrefix = "page_view"
    }

    private let survicate: SurvicateSdk?
    weak var delegate: KovaleeSurveyDelegate?

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

    func sendEvent(with name: String, andProperties properies: [String : Any]?) {
        
        if isPageView(name) {
            viewScreen(with: name)
        } else {
            let stringOnlyProperties = properies?.compactMapValues { $0 as? String }
            guard let stringOnlyProperties else { return }

            survicate?.invokeEvent(name: name, with: stringOnlyProperties)
        }
    }

    func viewScreen(with name: String) {
        survicate?.enterScreen(value: name)
    }

    func setUserProperty(withName name: String, andValue value: String) {
        let userTrait = UserTrait(withName: name, value: value)
        survicate?.setUserTrait(userTrait)
    }

    func setAmplitudeUserId(userId: String) {
        let amplitudeIdUserTrait = UserTrait(withName: Constants.amplitudeUserIdKey, value: userId)
        survicate?.setUserTrait(amplitudeIdUserTrait)
    }

    func setSurveyDelegate(_ delegate: KovaleeSurveyDelegate) {
        self.delegate = delegate
    }
}

private extension KovaleeSurveyManagerImpl {

    func isPageView(_ eventName: String) -> Bool {
        return eventName.contains(Constants.pageViewEventNamePrefix)
    }
}

extension KovaleeSurveyManagerImpl: SurvicateDelegate {
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
