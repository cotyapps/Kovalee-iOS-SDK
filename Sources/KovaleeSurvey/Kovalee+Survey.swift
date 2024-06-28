import KovaleeSDK
import KovaleeFramework

extension SurveyManagerCreator: Creator {
    public func createImplementation(
        withConfiguration configuration: Configuration,
        andKeys keys: KovaleeKeys
    ) -> Manager {
        return KovaleeSurveyManagerImpl(withKey: keys.survicate?.sdkId)
    }
}

extension Kovalee {

    /// Sets the delegate for Survey actions
    ///
    /// - Parameters:
    ///    - delegate: the delegate that will perform Survey actions
    public static func setSurveyDelegate(_ delegate: KovaleeSurveyDelegate) {
        Self.shared.kovaleeManager?.setSurveyDelegate(delegate)
    }
}
