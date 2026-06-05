import Foundation
import KovaleeFramework

struct CompositeEventTracker: EventTrackerManager, Manager {
    let trackers: [EventTrackerManager]

    func sendEvent(_ event: Event) {
        trackers.forEach { $0.sendEvent(event) }
    }

    func setUserId(_ userId: String) {
        trackers.forEach { $0.setUserId(userId) }
    }

    func setDeviceId(_ deviceId: String) {
        trackers.forEach { $0.setDeviceId(deviceId) }
    }

    func setUserProperty(key: String, value: String) {
        trackers.forEach { $0.setUserProperty(key: key, value: value) }
    }

    func setUserProperty(property: UserProperty) {
        trackers.forEach { $0.setUserProperty(property: property) }
    }

    func setUserProperties(_ properties: [String: String]) {
        trackers.forEach { $0.setUserProperties(properties) }
    }

    func setDataCollectionEnabled(_ enabled: Bool) {
        trackers.forEach { $0.setDataCollectionEnabled(enabled) }
    }

    func flush() {
        trackers.forEach { $0.flush() }
    }

    // Identity queries: return the first non-nil answer — Amplitude is added
    // first in the init wiring, so those IDs win (they're the ones existing
    // call-sites expect).
    func getUserId() -> String? {
        for t in trackers { if let id = t.getUserId() { return id } }
        return nil
    }

    func getDeviceId() -> String? {
        for t in trackers { if let id = t.getDeviceId() { return id } }
        return nil
    }
}
