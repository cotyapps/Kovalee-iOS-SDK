import Foundation

/// One-shot AB test override used by the SDK debug panel.
/// When an override is pending we:
///   1. Clear the framework's persisted AB experiment value (`KV_ab_experiment_value`)
///      before `KovaleeManager` hydrates its `SDKState`, so the binary's
///      internal cache is empty.
///   2. Return the override from `FirebaseWrapperImpl.value(forKey:)` when the
///      binary then asks for the AB test key.
/// The binary stores the value we returned as its new persisted state, and the
/// override is cleared so it never carries past a single launch.
public enum AbTestOverride {
    public static let enabledKey = "kovalee.abTestOverride.enabled"
    public static let valueKey = "kovalee.abTestOverride.value"

    // UserDefaults keys used by the framework binary to persist the AB experiment value.
    private static let frameworkValueKey = "KV_ab_experiment_value"
    private static let frameworkKeyKey = "KV_ab_experiment_key"

    /// Returns the override value without consuming it. Used to decide whether
    /// the framework's stored state needs to be wiped before init.
    static func peek() -> String? {
        let defaults = UserDefaults.standard
        guard defaults.bool(forKey: enabledKey) else { return nil }
        let value = defaults.string(forKey: valueKey) ?? ""
        return value.isEmpty ? nil : value
    }

    /// Called from `Kovalee.initialize` before `KovaleeManager` is created.
    /// When an override is pending, wipes the framework's stored AB experiment
    /// value so the binary's `SDKState` hydrates empty and the next fetch falls
    /// through to `FirebaseWrapperImpl.value(forKey:)`.
    static func clearFrameworkStateIfPending() {
        guard peek() != nil else { return }
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: frameworkValueKey)
        defaults.removeObject(forKey: frameworkKeyKey)
    }

    public static func consume() -> String? {
        let defaults = UserDefaults.standard
        guard defaults.bool(forKey: enabledKey) else { return nil }
        defer {
            defaults.removeObject(forKey: enabledKey)
            defaults.removeObject(forKey: valueKey)
        }
        let value = defaults.string(forKey: valueKey) ?? ""
        return value.isEmpty ? nil : value
    }
}
