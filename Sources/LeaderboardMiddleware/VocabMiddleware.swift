import DatabaseClient
import Either
import HttpPipeline
import MemberwiseInit
import Overture
import Prelude
import SharedModels

@MemberwiseInit(.public)
public struct FetchVocabLeaderboardRequest {
  @Init(.public) let currentPlayer: Player
  @Init(.public) let database: DatabaseClient
  @Init(.public) let language: Language
  @Init(.public) let timeScope: TimeScope
}

public func fetchVocabLeaderboard(
  _ conn: Conn<StatusLineOpen, FetchVocabLeaderboardRequest>
) -> IO<Conn<HeadersOpen, Either<ApiError, [FetchVocabLeaderboardResponse.Entry]>>> {

  let request = conn.data

  return request.database.fetchVocabLeaderboard(
    request.language,
    request.currentPlayer,
    request.timeScope
  )
  .run
  .flatMap { errorOrEntries in
    switch errorOrEntries {
    case let .left(error):
      return conn.map(const(.left(ApiError(error: error))))
        |> writeStatus(.internalServerError)

    case let .right(entries):
      return conn.map(const(.right(entries)))
        |> writeStatus(.ok)
    }
  }
}

@MemberwiseInit(.public)
public struct FetchVocabWordRequest {
  @Init(.public) let database: DatabaseClient
  @Init(.public) let wordId: Word.Id
}

public func fetchVocabWord(
  _ conn: Conn<StatusLineOpen, FetchVocabWordRequest>
) -> IO<Conn<HeadersOpen, Either<ApiError, FetchVocabWordResponse>>> {

  let request = conn.data

  return request.database.fetchVocabLeaderboardWord(request.wordId)
    .run
    .flatMap { errorOrResponse in
      switch errorOrResponse {
      case let .left(error):
        return conn.map(const(.left(ApiError(error: error))))
          |> writeStatus(.badRequest)

      case let .right(response):
        return conn.map(const(.right(response)))
          |> writeStatus(.ok)
      }
    }
}
