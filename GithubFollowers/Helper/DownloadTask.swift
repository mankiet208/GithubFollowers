//
//  DownloadTask.swift
//  GithubFollowers
//
//  Created by Kiet Truong on 28/10/2024.
//

import Foundation

protocol DownloadTaskDelegate: AnyObject {
    func downloadTask(progress: Float)
}

class DownloadTask: NSObject {
    
    weak var delegate: DownloadTaskDelegate?
    
    private var configuration: URLSessionConfiguration
    
    private lazy var session: URLSession = {
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: .main)
        return session
    }()
        
    override init() {
        self.configuration = URLSessionConfiguration.background(withIdentifier: "backgroundTasks")
        super.init()
    }
    
    func start(with url: URL) {                
        let task = session.downloadTask(with: url)
        task.resume()
    }
}

extension DownloadTask: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        print("> Download complete")
    }
    
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        DispatchQueue.main.async {
            if totalBytesExpectedToWrite == -1 {
                // Response header must have "Content-Length"
                self.delegate?.downloadTask(progress: 0)
            } else {
                let current = Float(totalBytesWritten)
                let total = Float(totalBytesExpectedToWrite)
                
                let progress = Float(Double(current / total).roundToDecimal(digits: 2))
                self.delegate?.downloadTask(progress: progress)
            }
        }
    }
}
