import Alchemy
import APNSwift

// MARK: Aliases

public var APNS: APNSMessenger { .default }
public func APNS(_ id: APNSMessenger.Identifier) -> APNSMessenger { .id(id) }

// MARK: SMSMessenger

public typealias APNSMessenger = Messenger<APNSChannel>

extension APNSMessenger {
    public func send(_ message: APNSwiftPayload, toDeviceToken token: String) async throws {
        try await send(message, to: APNSDevice(deviceToken: token))
    }
    
    public func send(title: String, body: String, to receiver: APNSReceiver) async throws {
        let alert = APNSwiftAlert(title: title, body: body)
        let payload = APNSwiftPayload(alert: alert)
        try await send(payload, to: receiver.apnsDevice)
    }

    public func send(title: String, body: String, to device: APNSDevice) async throws {
        let alert = APNSwiftAlert(title: title, body: body)
        let payload = APNSwiftPayload(alert: alert)
        try await send(payload, to: device)
    }
}

// MARK: Config + APNS

extension AnyChannelConfig where Self == APNSMessenger.ChannelConfig {
    public static func apns(_ messengers: [APNSMessenger.Identifier: APNSMessenger]) -> AnyChannelConfig {
        APNSMessenger.ChannelConfig(messengers: messengers)
    }
}
