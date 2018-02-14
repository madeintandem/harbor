final class ListUserProjects {
  private let repo: UserProjectRepo

  init (repo: UserProjectRepo) {
    self.repo = repo
  }

  func list() -> UserProjectFuture<[Project]> {
    return repo.all()
  }
}
