import DatabaseClient
import Either
import HttpPipeline
import MemberwiseInit
import Overture
import Prelude
import SharedModels

@MemberwiseInit(.public)
public struct FetchWeekInReviewRequest {
  @Init(.public) let currentPlayer: Player
  @Init(.public) let database: DatabaseClient
  @Init(.public) let language: Language
}

public func fetchWeekInReview(
  _ conn: Conn<StatusLineOpen, FetchWeekInReviewRequest>
) -> IO<Conn<HeadersOpen, Either<ApiError, FetchWeekInReviewResponse>>> {

  let request = conn.data

  let weekInReview =
    tuple
    <¢> request.database.fetchLeaderboardWeeklyRanks(
      request.language,
      request.currentPlayer
    )
    .run
    .parallel
    <*> request.database.fetchLeaderboardWeeklyWord(
      request.language,
      request.currentPlayer
    )
    .run
    .parallel

  return weekInReview
    .sequential
    .map { ranks, word in
      ranks.flatMap { ranks in
        word.map { word in FetchWeekInReviewResponse(ranks: ranks, word: word) }
      }
    }
    .flatMap { errorOrEntries in
      switch errorOrEntries {
      case let .left(error):
        return conn.map(const(.left(ApiError(error: error))))
          |> writeStatus(.internalServerError)

      case let .right(response):
        return conn.map(const(.right(response)))
          |> writeStatus(.ok)
      }
    }
}
