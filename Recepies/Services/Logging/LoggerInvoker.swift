// LoggerInvoker.swift


import Foundation

/// Save user activities logs
final class LoggerInvoker {
    // MARK: - Singletone

    static let shared = LoggerInvoker()
    private init() {}

    // MARK: - Private Prperties

    private let logger = Logger()
    private let batchSize = 1
    private var commands: [LogCommand] = []

    // MARK: - Public Methods

    func addLogCommand(_ command: LogCommand) {
        commands.append(command)
        executeCommandsIfNeeded()
    }

    // MARK: - Private Methods

    private func executeCommandsIfNeeded() {
        guard commands.count >= batchSize else { return }
        for command in commands {
            logger.writeMessageToLog(command.logMessage)
            commands = []
        }
    }
}
