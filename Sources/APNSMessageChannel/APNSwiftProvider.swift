import Alchemy
import APNSwift
import AsyncKit
import JWTKit

extension APNSMessenger {
    public static func apnswift(config: APNSwiftConfiguration) -> APNSMessenger {
        Messenger(provider: APNSwiftProvider(config: config))
    }
    
    public static func apnswift(keyfilePath: String, keyIdentifier: String, teamIdentifier: String, topic: String, environment: APNSwiftConfiguration.Environment) -> APNSMessenger {
        do {
            return Messenger(
                provider: APNSwiftProvider(
                    config: APNSwiftConfiguration(
                        authenticationMethod: .jwt(
                            key: try .private(filePath: keyfilePath),
                            keyIdentifier: JWKIdentifier(string: keyIdentifier),
                            teamIdentifier: teamIdentifier
                        ),
                        topic: topic,
                        environment: environment
                    )
                )
            )
        } catch {
            preconditionFailure("Error creating APNs configuration \(error)! Perhaps there isn't a file at the given path?")
        }
    }
}

private struct APNSwiftProvider: ChannelProvider {
    typealias C = APNSChannel
    
    private let pool: EventLoopGroupConnectionPool<APNSConnectionSource>
    
    init(config: APNSwiftConfiguration) {
        let source = APNSConnectionSource(configuration: config)
        self.pool = EventLoopGroupConnectionPool<APNSConnectionSource>(source: source, logger: Log.logger, on: Loop.group)
    }
    
    func send(message: APNSwiftPayload, to device: APNSDevice) async throws {
        return try await pool.withConnection { connection in
            try await connection.send(message, pushType: .alert, to: device.deviceToken).get()
        }
    }

    func shutdown() throws {
        try pool.syncShutdownGracefully()
    }
}

private struct APNSConnectionSource: ConnectionPoolSource {
    let configuration: APNSwiftConfiguration

    init(configuration: APNSwiftConfiguration) {
        self.configuration = configuration
    }
    
    func makeConnection(logger: Logger, on eventLoop: EventLoop) -> EventLoopFuture<APNSwiftConnection> {
        APNSwiftConnection.connect(configuration: self.configuration, on: eventLoop)
    }
}

extension APNSwiftConnection: ConnectionPoolItem {
    public var eventLoop: EventLoop {
        channel.eventLoop
    }

    public var isClosed: Bool {
        !channel.isActive
    }
}
