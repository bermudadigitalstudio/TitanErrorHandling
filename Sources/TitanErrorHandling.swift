import TitanCore

public let DefaultErrorHandler: (Error) -> (ResponseType) = { err in
  return Response(code: 500, body: String(describing: err), headers: [])
}

extension Titan {
  public func addFunction(errorHandler: @escaping (Error) -> (ResponseType), handler: @escaping ThrowingFunction) {
    self.addFunction(toFunction(handler, errorHandler: errorHandler))
  }
}

public typealias ThrowingFunction = (RequestType, ResponseType) throws -> (RequestType, ResponseType)

/// Convert a throwing function to a non throwing function, calling the specified error handler in case of throws.
public func toFunction(_ handler: @escaping ThrowingFunction, errorHandler: @escaping (Error) -> (ResponseType)) -> Function {
    return { req, res in
      do {
        return try handler(req, res)
      } catch {
        return (req, errorHandler(error))
      }
    }
}
