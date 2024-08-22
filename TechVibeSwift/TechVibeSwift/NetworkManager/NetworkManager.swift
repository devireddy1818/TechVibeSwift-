//
import Alamofire
enum Result<Data> {
    case success(Any)
    case error(ErrorResponse)
}

enum HTTPMethods: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
    case options = "OPTIONS"
    case trace = "TRACE"
    case connect = "CONNECT"
}

protocol ErrorResponse {
    var error: String { get }
    var message: String? { get }
    var description: String { get }
    
    var loggingErrorCode: Int? { get set }
    var loggingError: Error { get }
}


struct AuthenticationError: ErrorResponse, Equatable, Codable {
    let error: String = "Unauthenticated"
    let message: String? = "Your session is invalid or has expired"
    var loggingErrorCode: Int?
    
    var description: String { return message ?? error }
    var loggingError: Error { return NSError(domain: "", code: loggingErrorCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "AuthenticationError - \(message ?? error)"]) as Error }
}
struct APIError: ErrorResponse, Equatable, Codable {
    var error: String = ""
    
    var message: String? = ""
    
    var description: String = ""
    
    var loggingErrorCode: Int? = -1
    
    var loggingError: Error {return NSError(domain: "", code: loggingErrorCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "AuthenticationError - \(message ?? error)"]) as Error}
    
    
}
protocol NetworkAdapter {
    func request(
        _ url: URL,
        method: String,
        parameters: [String: Any]?,
        headers: [String: String]?,
        completion: @escaping (Result<Data>) -> Void)
    -> Void
}

class AlamofireNetworkAdapter: NetworkAdapter {
    static var shared = AlamofireNetworkAdapter()
    private var sessionManager: Session?
    init() {
        sessionManager = Session(configuration: .default, serverTrustManager: nil)
    }
    
    func request(_ url: URL, method: String, parameters: [String : Any]?, headers: [String : String]?, completion: @escaping (Result<Data>) -> Void) {
        let httpMethod = HTTPMethod(rawValue: method)
        //  let encryptedparams = encryptParameters(parameters)
        let encoding: ParameterEncoding = httpMethod == .post ? URLEncoding.default : JSONEncoding.default
        sessionManager?.request(url, method: httpMethod, parameters: parameters, encoding: encoding, headers:nil)
            .validate()
            .validate().responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let JSON = value as? [String: Any] {
                        print(JSON)
                    }
                    completion(.success(value))
                case .failure(let error):
                    let error = APIError(error: error.localizedDescription, message: error.localizedDescription, description: error.errorDescription ?? "", loggingErrorCode: error.responseCode)
                    completion(.error(error))
                    break
                    // error handling
                }
                if let data = response.data {
                    /* Authorization validation */
                    if let _ = response.error as NSError?, let response = response.response, response.statusCode == 401 {
                        var error = AuthenticationError()
                        error.loggingErrorCode = response.statusCode
                        completion(.error(error))
                        return
                    }
                }
            }
    }
    
    func getURL(from urlString: String, serviceAPI: String) -> URL? {
        let url = urlString+serviceAPI
        return URL(string: url)
    }
}


