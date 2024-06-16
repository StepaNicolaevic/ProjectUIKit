// Logger.swift


import Foundation

/// Write down log messages into log file in Sandbox
final class Logger {
    // MARK: - Constants

    private enum Constants {
        static let folderName = "Logs"
        static let fileName = "log.txt"
    }

    // MARK: - Private properties

    private let fileManager = FileManager.default
    private var logFolderPath: URL? {
        let sandBoxPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        return sandBoxPath?.appendingPathComponent(Constants.folderName, conformingTo: .utf8PlainText)
    }

    private var logFilePath: URL? {
        logFolderPath?.appendingPathComponent(Constants.fileName, conformingTo: .utf8PlainText)
    }

    // MARK: - Public Methods

    func writeMessageToLog(_ message: String) {
        makeLogFolderIfNeeded()
        do {
            try makeLogFileText(with: message).write(
                toFile: logFilePath?.path ?? "",
                atomically: true,
                encoding: .utf8
            )
        } catch {
            print("Error writing to file \(error)")
        }
    }

    // MARK: - Private Methods

    private func makeLogFolderIfNeeded() {
        guard let logFolderPath else {
            print("Folder path is incorrect")
            return
        }
        guard !fileManager.fileExists(atPath: logFolderPath.path) else { return }
        do {
            try fileManager.createDirectory(atPath: logFolderPath.path, withIntermediateDirectories: true)
            print("Folder is created")
        } catch {
            print("Error creating folder \(error)")
        }
    }

    private func makeLogFileText(with message: String) -> String {
        guard let logFilePath = logFilePath?.path else { return message }
        guard fileManager.fileExists(atPath: logFilePath) else { return message }
        do {
            let currentMessage = try String(contentsOfFile: logFilePath)
            return "\(currentMessage) \n\(message)"
        } catch {
            print("Error reading file \(error)")
            return message
        }
    }
}
