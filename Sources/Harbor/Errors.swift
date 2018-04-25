public extension Error where Self: CustomStringConvertible {
  var localizedDescription: String {
    return description
  }
}

// MARK: Actions
extension User.SignIn.Failure {
  public var description: String {
    switch self {
      case .nested(let error):
        return error.localizedDescription
    }
  }
}

extension User.SignInCurrent.Failure: CustomStringConvertible {
  public var description: String {
    switch self {
      case .noCredentials:
        return "no saved credentials, please sign in"
      case .nested(let error):
        return error.localizedDescription
    }
  }
}

extension User.ListProjects.Failure: CustomStringConvertible {
  public var description: String {
    switch self {
      case .hasNoUser:
        return "no current user, please sign in"
      case .nested(let error):
        return error.localizedDescription
    }
  }
}

extension Project.ListBuilds.Failure: CustomStringConvertible {
  public var description: String {
    switch self {
      case .nested(let error):
        return error.localizedDescription
    }
  }
}

extension Project.ListBuildsByPosition.Failure: CustomStringConvertible {
  public var description: String {
    switch self {
      case .hasNoUser:
        return "no current user, please sign in"
      case .hasNoOrganization(let index):
        return "no org with index \(index) for current user"
      case .hasNoProject(let org, let index):
        return "no project in org \(org.name) with index \(index) for current user"
      case .nested(let error):
        return error.localizedDescription
    }
  }
}

// MARK: Services
extension Auth.Failure: CustomStringConvertible {
  public var description: String {
    switch self {
      case .badCredentials:
        return "credentials were malformed, please sign in"
      case .unauthorized:
        return "credentials were invalid"
    case .network(let error):
        return error.localizedDescription
    }
  }
}

extension FetchProjects.Failure: CustomStringConvertible {
  public var description: String {
    switch self {
      case .unauthenticated:
        return "no current user, please sign in"
      case .network(let error):
        return "network error: \(error)"
    }
  }
}

extension FetchBuilds.Failure: CustomStringConvertible {
  public var description: String {
    switch self {
      case .unauthenticated:
        return "no current user, please sign in"
      case .network(let error):
        return "network error: \(error)"
    }
  }
}
