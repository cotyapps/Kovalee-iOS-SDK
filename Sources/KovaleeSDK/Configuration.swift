import Foundation
import KovaleeFramework

/// A type that describes how to configure ``Kovalee``
public struct Configuration {
    /// The type of environment
    ///
    /// ### Environment
    ///
    /// - ``development``
    /// - ``production``
    /// - ``test``
    public enum Environment: String {
        case development
        case production

        /// this should only be used for testing purposes
        case test
    }

    /// Configuration environment type
    public var environment: Environment
    /// Configuration log level
    public var logLevel: KovaleeFramework.LogLevel
    public var keysFileUrl: URL?
    public var alreadyIntegrated: Bool
    public var enableExperimentalFeature: Bool
    public var enableAmplitudeInDevelopment: Bool = false

    /// Creates a configuration with environment, keys file name, and log level.
    ///
    /// Keys file name is set to a default value of KovaleeKeys
    ///
    /// - Parameters:
    ///   - environment: The environment type
    ///   - keysFileName: The file name for the keys
    ///   - logLevel: The configuration log levels
    ///   - experimentalFeatureEnabled: enable any new experimental feature
    ///   - enableAmplitudeInDevelopment: enable Amplitude in development environment (default is false)
    public init(
        environment: Environment,
        keysFileName: String = KovaleeConstants.keysFileName,
        logLevel: KovaleeFramework.LogLevel = .info,
        alreadyIntegrated: Bool = false,
        enableExperimentalFeature: Bool = false,
        enableAmplitudeInDevelopment: Bool = false
    ) {
        self.environment = environment
        keysFileUrl = Bundle.main.url(
            forResource: keysFileName,
            withExtension: "json"
        )
        self.logLevel = logLevel
        self.alreadyIntegrated = alreadyIntegrated
        self.enableExperimentalFeature = enableExperimentalFeature
        self.enableAmplitudeInDevelopment = enableAmplitudeInDevelopment
    }

    init(
        environment: Environment,
        fileUrl: URL?,
        logLevel: LogLevel = .info,
        alreadyIntegrated: Bool = false,
        enableExperimentalFeature: Bool = false
    ) {
        self.environment = environment
        keysFileUrl = fileUrl
        self.logLevel = logLevel
        self.alreadyIntegrated = alreadyIntegrated
        self.enableExperimentalFeature = enableExperimentalFeature
    }
}

public extension Configuration {
    static func test(keysFileUrl: URL) -> Self {
        Self(environment: .test, fileUrl: keysFileUrl)
    }

    static var preview: Self {
        Self(environment: .test, fileUrl: nil)
    }

    static func currentLogLevel(fromRawValue logLevel: Int) -> LogLevel? {
        LogLevel(rawValue: logLevel)
    }
}
