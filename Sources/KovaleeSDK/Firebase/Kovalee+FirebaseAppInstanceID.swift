import Foundation
import KovaleeFramework

#if canImport(FirebaseCore)
    import FirebaseCore
#endif
#if canImport(FirebaseAnalytics)
    import FirebaseAnalytics
#endif

public extension Kovalee {
    /// The Firebase Analytics app-instance ID for the current install.
    ///
    /// This is the identifier Firebase keys its analytics user on. It is only
    /// available once Firebase has been configured (which Kovalee does during
    /// ``Kovalee/initialize(configuration:)``) and analytics collection is
    /// enabled — otherwise this returns `nil`.
    ///
    /// Forwarding this value to RevenueCat as the reserved
    /// `$firebaseAppInstanceId` subscriber attribute lets RevenueCat deliver
    /// subscription events back into the matching Firebase user. See
    /// https://www.revenuecat.com/docs/integrations/third-party-integrations/firebase-integration#2-set-firebase-user-identity-in-revenuecat
    ///
    /// - Returns: the Firebase app-instance ID, or `nil` if Firebase isn't
    ///   configured / analytics collection is disabled.
    static func firebaseAppInstanceID() -> String? {
        #if canImport(FirebaseAnalytics)
            #if canImport(FirebaseCore)
                // Defensive: reading the app-instance ID before FirebaseApp is
                // configured would be meaningless (and logs an error).
                guard FirebaseApp.app() != nil else { return nil }
            #endif
            return Analytics.appInstanceID()
        #else
            return nil
        #endif
    }
}
