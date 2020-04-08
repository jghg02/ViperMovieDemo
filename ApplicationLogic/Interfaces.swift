//
//  Overview.swift
//  InterfaceAdapters
//
//  Created by Sasmito Adibowo on 15/3/20.
//  Copyright © 2020 Basil Salad Software. All rights reserved.
//

import UIKit
import DomainEntities

// MARK: - User Interface

// MARK: Routers


public protocol MovieBrowserWireframe: class {
    var rootViewController: UIViewController { get }
    func present(movieDetail: MovieDetailPresenter, from: UIViewController)
    func present(error: Error, from sourceVC: UIViewController, retryHandler: (() -> Void)? )
}

public func createMovieBrowserWireframe(dataProvider: MovieDataProvider) -> MovieBrowserWireframe {
    MovieBrowserWireframeImp(dataProvider: dataProvider)
}

// MARK: MovieListPresenter

public protocol MovieListPresenter: class {
    var output: MovieListPresenterOutput? {get set}
    var numberOfItems: Int { get }
    func configureCell(_ cell: MovieSummaryPresenterOutput, forItemAt: Int)
    func loadInitialItems()
    func loadMoreItems()
    func showDetailOfItem(at indexPath: Int)
    var loadBatchSize: Int { get set }
}


public protocol MovieListPresenterOutput: UIViewController {
    func presenter(_ presenter: MovieListPresenter, didAddItemsAt indexes: IndexSet)
}

// MARK: MovieDetailPresenter

public protocol MovieDetailPresenter: class {
    var output: MovieDetailPresenterOutput? {get set}
    var hasDetail: Bool { get }
    
    var movieTitleText: String? { get }
    var movieRuntimeText: String? { get }
    var movieTaglineText: String? { get }
    var movieReleaseDateText: String? { get }
    
    func refreshDetail()
}


public protocol MovieDetailPresenterOutput: UIViewController {
    func presenterDidUpdateMovieDetail(_ presenter: MovieDetailPresenter)
}

// MARK: MovieSummaryPresenter

public protocol MovieSummaryPresenter: class {
    var output: MovieSummaryPresenterOutput? { get set}
    var movieSummary: MovieSummary { get }
}

public protocol MovieSummaryPresenterOutput: class {
    var movieID: MovieIdentifier? {get set}
    func setMovieOriginalTitle(_ title: String?)
}


// MARK: Views


// MARK: View Controllers


protocol DetailViewController: UIViewController {
    var isEmpty: Bool { get }
}


// MARK: - Network


// MARK: Data Provider
public protocol MovieSummaryResult {
    var pageNumber: UInt? { get }
    var totalResults: UInt? { get }
    var totalPages: UInt? { get }
    var results: [MovieSummary]? { get }
}


public protocol MovieDataProvider {
    var defaultPageSize: Int { get }
    func fetchMovieSummaries(
        filter: [(attribute: MovieFilterAttribute, value: Any, isAscending: Bool)],
        sort: (attribute: MovieSortAttribute, isAscending: Bool)?,
        pageNumber: Int?,
        resultReceiver: @escaping ( _ : Result<MovieSummaryResult>) -> Void )
    func fetchMovieDetail(movieID: MovieIdentifier, resultReceiver: @escaping (Result<MovieDetail>) -> Void)
}


// MARK: Network Errors

public enum NetworkErrorCode: Int {
    case noError
    case internalError
    case unknownHTTPStatusCode
    case noData
    case dataParseError
    case dataFormatError
    case missingFieldError
}

public let NetworkErrorDomain = "com.basilsalad.common.NetworkErrorDomain"


public extension NSError {
    convenience init(code: NetworkErrorCode, userInfo: [String : Any]? = nil) {
        self.init(domain: NetworkErrorDomain, code: code.rawValue, userInfo: userInfo)
    }
}

// MARK: HTTP Status

public enum HTTPStatusCode: Int {
    // 100 Informational
    case `continue` = 100
    case switchingProtocols
    case processing
    // 200 Success
    case okay = 200
    case created
    case accepted
    case nonAuthoritativeInformation
    case noContent
    case resetContent
    case partialContent
    case multiStatus
    case alreadyReported
    case instanceManipulationUsed = 226
    // 300 Redirection
    case multipleChoices = 300
    case movedPermanently
    case found
    case seeOther
    case notModified
    case useProxy
    case switchProxy
    case temporaryRedirect
    case permanentRedirect
    // 400 Client Error
    case badRequest = 400
    case unauthorized
    case paymentRequired
    case forbidden
    case notFound
    case methodNotAllowed
    case notAcceptable
    case proxyAuthenticationRequired
    case requestTimeout
    case conflict
    case gone
    case lengthRequired
    case preconditionFailed
    case payloadTooLarge
    case URITooLong
    case unsupportedMediaType
    case rangeNotSatisfiable
    case expectationFailed
    case imATeapot
    case misdirectedRequest = 421
    case unprocessableEntity
    case locked
    case failedDependency
    case upgradeRequired = 426
    case preconditionRequired = 428
    case tooManyRequests
    case requestHeaderFieldsTooLarge = 431
    case unavailableForLegalReasons = 451
    // 500 Server Error
    case internalServerError = 500
    case notImplemented
    case badGateway
    case serviceUnavailable
    case gatewayTimeout
    case versionNotSupported
    case variantAlsoNegotiates
    case insufficientStorage
    case loopDetected
    case notExtended = 510
    case networkAuthenticationRequired
    
    public func isGood() -> Bool {
        !(rawValue >= 400 && rawValue < 600)
    }
}

public let HTTPStatusErrorDomain = "com.basilsalad.common.HTTPStatusErrorDomain"

public extension NSError {
    convenience init(code: HTTPStatusCode, userInfo: [String : Any]? = nil) {
        self.init(domain: HTTPStatusErrorDomain, code: code.rawValue, userInfo: userInfo)
    }
}

