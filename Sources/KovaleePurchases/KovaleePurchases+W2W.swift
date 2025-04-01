import KovaleeFramework
import KovaleeSDK
import SwiftUI
import UIKit

// MARK: - Web2Web

public extension Kovalee {
    /// Determines if a web user has an active premium subscription or entitlement based on a deep link URL.
    ///
    /// This utility function combines the login process using a deep link URL and checks if the user has a premium status.
    /// It first authenticates the user using the provided deep link and then queries the premium status for the user.
    ///
    /// - Parameters:
    ///    - url: A `URL` representing the full deep link containing the user credentials in the query parameters.
    ///           The URL must include a `user_id` parameter and have the host `web2web`.
    ///
    /// - Returns: A `Bool` indicating whether the web user has an active premium status.
    ///            Returns `true` if the user has active subscriptions or entitlements, and `false` otherwise.
    ///
    /// - Throws: An error if the login process or the premium status retrieval fails.
    ///
    /// ### Example Deep Link URL
    /// ```
    /// https://example.com/web2web?user_id=123456789
    /// yourapp_deeplink://web2web?user_id=123456789
    /// ```
    ///
    /// ### Example Usage UIKit
    /// ```swift
    /// func application(
    ///     _ application: UIApplication,
    ///     open url: URL,
    ///     options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    /// ) -> Bool {
    ///     Task {
    ///         do {
    ///             let isPremium = try await Kovalee.isWebUserPremium(withUrl: url)
    ///             print("Is the web user premium? \(isPremium)")
    ///         } catch {
    ///             print("Error checking premium status for web user: \(error)")
    ///         }
    ///     }
    ///     return true
    /// }
    /// ```
    /// ### Example usage SwiftUI
    ///  ```swift
    ///  struct ContentView: View {
    ///        var body: some View {
    ///             VStack {
    ///             }
    ///             .onOpenURL { incomingURL in
    ///                 Task {
    ///                     let isPremium = try? await Kovalee.isWebUserPremium(incomingURL)
    ///                     print("Is the web user premium? \(isPremium)")
    ///                 }
    ///             }
    ///         }
    ///     }
    ///  ```
    static func isWebUserPremium(withUrl url: URL) async throws -> Bool {
        guard let userId = handleIncomingURL(url) else {
            return false
        }

        return try await handleWebUser(withId: userId)
    }

    /// Checks if the user has an active premium subscription by extracting a user ID from the clipboard.
    ///
    /// This function reads the clipboard content and verifies if it contains a valid UUID (user ID).
    /// then asynchronously determines if the user has an active premium status.
    ///
    /// - Returns: A `Bool` indicating whether the user has an active premium subscription.
    ///            Returns `true` if the user has an active subscription or entitlement, and `false` otherwise.
    ///
    /// - Throws: An error if setting the user ID in RevenueCat fails or if the premium status retrieval fails.
    ///
    /// ## Validation:
    /// - The clipboard content must be a valid UUID (`xxxxxxxx-xxxx-Mxxx-Nxxx-xxxxxxxxxxxx`).
    /// - If the clipboard content does not match the expected UUID format, the function returns `false` without making any API calls.
    ///
    /// ## Example Usage:
    /// ```swift
    /// Task {
    ///     do {
    ///         let isPremium = try await Kovalee.checkWebUserFromClipboard()
    ///         print("Is the user from clipboard premium? \(isPremium)")
    ///     } catch {
    ///         print("Error checking premium status from clipboard: \(error)")
    ///     }
    /// }
    /// ```
    static func checkWebUserFromClipboard() async throws -> Bool {
        guard
            let clipboardUserId = UIPasteboard.general.string,
            clipboardUserId.range(of: "^[a-f0-9\\-]{36}$", options: .regularExpression) != nil
        else {
            return false
        }

        return try await handleWebUser(withId: clipboardUserId)
    }

    private static func handleWebUser(withId userId: String) async throws -> Bool {
        _ = try await setRevenueCatUserId(userId: userId)
        setAmplitudeUserId(userId: userId)

        let isPremium = try await isUserPremium()
        if isPremium {
            Kovalee.setUserProperty(key: "web_premium", value: "true")
        }
        return isPremium
    }

    private static func handleIncomingURL(_ url: URL) -> String? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            KLogger.error("Invalid URL: \(url.absoluteString)")
            return nil
        }

        guard components.path == "/web2web" else {
            KLogger.error("We can't handle this action: \(components.host ?? "")")
            return nil
        }

        guard let userId = components.queryItems?.first(where: { $0.name == "user_id" })?.value else {
            KLogger.error("Missing user_id query parameter")
            return nil
        }
        return userId
    }
}

/// A `ViewModifier` that listens for deep link URLs and checks if a web user has an active premium status.
///
/// This modifier observes deep link URLs using `onOpenURL` and asynchronously determines the user's premium status
/// by calling `Kovalee.isWebUserPremium(withUrl:)`. The result is returned via a closure, allowing the view to react accordingly.
///
/// ## Usage
/// Attach this modifier to a view using `.checkWebUserPremium(isUserPremium:)`.
///
/// ```swift
/// struct ContentView: View {
///     @State private var isPremium: Bool = false
///     @State private var errorMessage: String?
///
///     var body: some View {
///         VStack {
///             Text(isPremium ? "Premium User" : "Regular User")
///                 .font(.headline)
///                 .padding()
///         }
///         .checkWebUserPremium(
///                isUserPremium: { premiumStatus in
///                    isPremium = premiumStatus
///                },
///                onError: { error in
///                    errorMessage = error
///                }
///            )
///     }
/// }
/// ```
/// - Parameters:
///   - isUserPremium: A closure that updates the UI based on the web user's premium status.
///   - onError: A closure that handles errors encountered while checking the premium status.
struct WebUserPremiumModifier: ViewModifier {
    var isUserPremium: @MainActor (Bool) -> Void
    var onError: @MainActor (String) -> Void

    func body(content: Content) -> some View {
        content
            .onOpenURL { incomingURL in
                Task {
                    do {
                        let isPremium = try await Kovalee.isWebUserPremium(withUrl: incomingURL)
                        await MainActor.run {
                            isUserPremium(isPremium)
                        }
                    } catch {
                        let errorMessage = "Failed to check web user premium status: \(error.localizedDescription)"
                        await MainActor.run {
                            onError(errorMessage)
                        }
                    }
                }
            }
    }
}

public extension View {
    /// Applies the `WebUserPremiumModifier` to the view, enabling it to check premium status from deep link URLs.
    ///
    /// - Parameters:
    ///   - isUserPremium: A closure that updates the UI based on the web user's premium status.
    ///   - onError: A closure that handles errors encountered while checking the premium status.
    /// - Returns: A modified view that listens for deep link URLs and updates the premium status accordingly.
    func checkWebUserPremium(
        isUserPremium: @escaping @MainActor (Bool) -> Void,
        onError: @escaping @MainActor (String) -> Void
    ) -> some View {
        modifier(WebUserPremiumModifier(isUserPremium: isUserPremium, onError: onError))
    }
}
