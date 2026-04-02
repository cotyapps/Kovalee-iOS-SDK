import Foundation
import KovaleeFramework

// MARK: CRM

public extension Kovalee {

    enum CRMError: Error {
        case initializationProblem
    }

    /// Creates a contact in Brevo CRM with the provided email and optional attributes.
    ///
    /// The SDK automatically attaches the app code, Amplitude user ID, and device ID.
    ///
    /// - Parameters:
    ///   - email: the email address for the Brevo contact
    ///   - gender: optional gender value ("MALE" or "FEMALE")
    ///   - age: optional age value
    ///   - locale: optional locale identifier
    ///   - country: optional country code
    static func createBrevoContact(
        email: String,
        gender: String? = nil,
        age: String? = nil,
        locale: String? = nil,
        country: String? = nil
    ) async throws {
        try await Kovalee.shared.kovaleeManager?.createBrevoContact(
            email: email,
            gender: gender,
            age: age,
            locale: locale,
            country: country
        )
    }
}
