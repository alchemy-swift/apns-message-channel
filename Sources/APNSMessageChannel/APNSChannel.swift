import Alchemy
import APNSwift

// MARK: APNSChannel

public struct APNSChannel: Channel {
    public typealias Message = APNSwiftPayload
    public typealias Receiver = APNSDevice
}

extension APNSwiftPayload {
    public func send<R: APNSReceiver>(to receiver: R, via sender: APNSMessenger = .default) async throws {
        try await sender.send(self, to: receiver.apnsDevice)
    }
}

public struct APNSDevice: Codable {
    public let deviceToken: String
}

extension APNSDevice: ExpressibleByStringInterpolation {
    public init(stringLiteral value: String) {
        self.init(deviceToken: value)
    }
}

// MARK: APNSReceiver

public protocol APNSReceiver {
    var deviceToken: String { get }
}

extension APNSReceiver {
    var apnsDevice: APNSDevice {
        APNSDevice(deviceToken: deviceToken)
    }
    
    public func send(push: APNSwiftPayload, via sender: APNSMessenger = .default) async throws {
        try await sender.send(push, to: apnsDevice)
    }
    
    public func send(push title: String, body: String, via sender: APNSMessenger = .default) async throws {
        let alert = APNSwiftAlert(title: title, body: body)
        try await sender.send(APNSwiftPayload(alert: alert), to: apnsDevice)
    }
}

extension APNSDevice: APNSReceiver {}
