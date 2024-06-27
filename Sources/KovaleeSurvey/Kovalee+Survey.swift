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
