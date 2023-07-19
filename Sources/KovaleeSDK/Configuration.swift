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
        logLevel: LogLevel = .info
    ) {
        self.environment = environment
        self.keysFileUrl = Bundle.main.url(
            forResource: keysFileName,
            withExtension: "json"
        )
        self.logLevel = logLevel
    }

    init(
        environment: Environment,
        fileUrl: URL?,
        logLevel: LogLevel = .info
    ) {
        self.environment = environment
        self.keysFileUrl = fileUrl
        self.logLevel = logLevel
    }
}

extension Configuration {
    public static func test(keysFileUrl: URL) -> Self {
        Self(environment: .test, fileUrl: keysFileUrl)
    }

	public static var preview: Self {
        Self(environment: .test, fileUrl: nil)
    }

	public static func currentLogLevel(fromRawValue logLevel: Int) -> LogLevel? {
		LogLevel.init(rawValue: logLevel)
	}
}
