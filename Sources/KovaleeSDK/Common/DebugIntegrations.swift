import Foundation

/// Live diagnostic card for an optional ad-SDK module (e.g. TikTok),
/// shown in the DebugView "Ad SDK Integrations" section.
///
/// Optional modules register their card when their `Creator` runs during
/// `Kovalee.initialize` — so a missing entry means "module not linked into
/// this app", which is itself the first thing the debug menu reports.
public struct KovaleeDebugIntegration: Sendable {
    /// Stable identifier the debug menu looks up (e.g. "tiktok").
    public let id: String
    /// Display title (e.g. "TikTok").
    public let title: String
    /// Ordered label/value rows, recomputed live on every render so the menu
    /// reflects the current state (consent, activation, buffered events…).
    public let fields: @Sendable () -> [KovaleeDebugIntegrationField]
    /// Action buttons rendered under the rows (e.g. "Send test event").
    public let actions: [KovaleeDebugIntegrationAction]

    public init(
        id: String,
        title: String,
        fields: @escaping @Sendable () -> [KovaleeDebugIntegrationField],
        actions: [KovaleeDebugIntegrationAction] = []
    ) {
        self.id = id
        self.title = title
        self.fields = fields
        self.actions = actions
    }
}

/// One label/value row of an integration card.
public struct KovaleeDebugIntegrationField: Sendable {
    public let label: String
    public let value: String

    public init(_ label: String, _ value: String) {
        self.label = label
        self.value = value
    }
}

/// One action button of an integration card.
public struct KovaleeDebugIntegrationAction: Sendable {
    public let label: String
    public let run: @Sendable () -> Void

    public init(_ label: String, run: @escaping @Sendable () -> Void) {
        self.label = label
        self.run = run
    }
}

/// Process-wide registry the optional modules publish their debug cards into.
public final class KovaleeDebugIntegrations: @unchecked Sendable {
    public static let shared = KovaleeDebugIntegrations()

    private let lock = NSLock()
    private var integrations: [KovaleeDebugIntegration] = []

    /// Registers (or replaces) a module's card. Called by the module's
    /// `Creator` during `Kovalee.initialize`.
    public func register(_ integration: KovaleeDebugIntegration) {
        lock.lock()
        defer { lock.unlock() }
        integrations.removeAll { $0.id == integration.id }
        integrations.append(integration)
    }

    /// The card registered under `id`, or `nil` when that module isn't linked.
    public func integration(withId id: String) -> KovaleeDebugIntegration? {
        lock.lock()
        defer { lock.unlock() }
        return integrations.first { $0.id == id }
    }
}
