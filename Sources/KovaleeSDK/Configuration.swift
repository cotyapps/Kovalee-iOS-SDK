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
    public var logLevel: LogLevel
    public var keysFileUrl: URL?
    public var alreadyIntegrated: Bool

    /// Creates a configuration with environment, keys file name, and log level.
    ///
    /// Keys file name is set to a defeult value of KovaleeKeys
    ///
    /// - Parameters:
    ///   - environment: The enviroment type
    ///   - keysFileName: The file name for the keys
    ///   - logLevel: The configuration log levels
    public init(
        environment: Environment,
        keysFileName: String = KovaleeConstants.keysFileName,
        logLevel: LogLevel = .info,
        alreadyIntegrated: Bool = false
    ) {
        self.environment = environment
        keysFileUrl = Bundle.main.url(
            forResource: keysFileName,
            withExtension: "json"
        )
        self.logLevel = logLevel
        self.alreadyIntegrated = alreadyIntegrated
    }

    init(
        environment: Environment,
        fileUrl: URL?,
        logLevel: LogLevel = .info,
        alreadyIntegrated: Bool = false
    ) {
        self.environment = environment
        keysFileUrl = fileUrl
        self.logLevel = logLevel
        self.alreadyIntegrated = alreadyIntegrated
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
