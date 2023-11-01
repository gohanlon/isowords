import DatabaseClient
import Either
import HttpPipeline
import MemberwiseInit
import Prelude
import SharedModels

@MemberwiseInit(.public)
public struct FetchLeaderboardRequest {
  @Init(.public) let currentPlayer: Player
  @Init(.public) let database: DatabaseClient
  @Init(.public) let gameMode: GameMode
  @Init(.public) let language: Language
  @Init(.public) let timeScope: TimeScope
}

public func fetchLeaderboardMiddleware(
  _ conn: Conn<StatusLineOpen, FetchLeaderboardRequest>
) -> IO<Conn<HeadersOpen, Either<ApiError, FetchLeaderboardResponse>>> {

  let request = conn.data

  return request.database
    .fetchRankedLeaderboardScores(
      .init(
        gameMode: request.gameMode,
        language: request.language,
        playerId: request.currentPlayer.id,
        timeScope: request.timeScope
      )
    )
    .map(FetchLeaderboardResponse.init(entries:))
    .run
    .flatMap { errorOrResponse in
      switch errorOrResponse {
      case let .left(error):
        return conn.map(const(.left(ApiError(error: error))))
          |> writeStatus(.internalServerError)

      case let .right(response):
        return conn.map(const(.right(response)))
          |> writeStatus(.ok)
      }
    }
}
