import KovaleeFramework
import KovaleeSDK

extension SurveyManagerCreator: Creator {
    public func createImplementation(
        withConfiguration _: Configuration,
        andKeys keys: KovaleeKeys
    ) -> Manager {
        return KovaleeSurveyManagerImpl(withKey: keys.survicate?.sdkId)
    }
}

public extension Kovalee {
    /// Sets the delegate for Survey actions
    ///
    /// - Parameters:
    ///    - delegate: the delegate that will perform Survey actions
    static func setSurveyDelegate(_ delegate: KovaleeSurveyDelegate) {
        shared.kovaleeManager?.setSurveyDelegate(delegate)
    }
}
