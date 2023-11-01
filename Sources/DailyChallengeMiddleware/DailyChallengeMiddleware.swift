import DatabaseClient
import Either
import Foundation
import HttpPipeline
import MemberwiseInit
import Prelude
import SharedModels

@MemberwiseInit(.public)
public struct FetchTodaysDailyChallengeRequest {
  @Init(.public) let currentPlayer: Player
  @Init(.public) let database: DatabaseClient
  @Init(.public) let language: Language
  @Init(.public) let randomCubes: () -> ArchivablePuzzle
}

public func fetchTodaysDailyChallengeMiddleware(
  _ conn: Conn<StatusLineOpen, FetchTodaysDailyChallengeRequest>
) -> IO<Conn<HeadersOpen, Either<ApiError, [FetchTodaysDailyChallengeResponse]>>> {

  let request = conn.data

  return sequence(
    GameMode.dailyChallengeModes
      .map { gameMode in
        request.database.createTodaysDailyChallenge(
          .init(
            gameMode: gameMode,
            language: request.language,
            puzzle: request.randomCubes()
          )
        )
        .flatMap { dailyChallenge in
          request.database.fetchDailyChallengeResult(
            .init(
              dailyChallengeId: dailyChallenge.id,
              playerId: request.currentPlayer.id
            )
          )
          .map { result in
            FetchTodaysDailyChallengeResponse(
              dailyChallenge: .init(
                endsAt: dailyChallenge.endsAt,
                gameMode: dailyChallenge.gameMode,
                id: dailyChallenge.id,
                language: dailyChallenge.language
              ),
              yourResult: result
            )
          }
        }
        .run
        .parallel
      }
  )
  .sequential
  .map(sequence)
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

@MemberwiseInit(.public)
public struct StartDailyChallengeRequest {
  public let currentPlayer: Player
  public let database: DatabaseClient
  public let gameMode: GameMode
  public let language: Language
}

public func startDailyChallengeMiddleware(
  _ conn: Conn<StatusLineOpen, StartDailyChallengeRequest>
) -> IO<Conn<HeadersOpen, Either<ApiError, StartDailyChallengeResponse>>> {

  let request = conn.data

  struct DailyChallengeModeNotFound: Error {
    let mode: GameMode
  }

  return request.database.fetchTodaysDailyChallenges(request.language)
    .flatMap {
      $0.first(where: { $0.gameMode == request.gameMode }).map(pure)
        ?? throwE(ApiError(error: DailyChallengeModeNotFound(mode: request.gameMode)))
    }
    .flatMap { dailyChallenge -> EitherIO<Error, StartDailyChallengeResponse> in
      request.database.startDailyChallenge(dailyChallenge.id, request.currentPlayer.id)
        .map {
          StartDailyChallengeResponse(dailyChallenge: dailyChallenge, dailyChallengePlayId: $0.id)
        }
    }
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

@MemberwiseInit(.public)
public struct FetchDailyChallengeResultsRequest {
  public let currentPlayer: Player
  public let database: DatabaseClient
  public let gameMode: GameMode
  public let gameNumber: DailyChallenge.GameNumber?
  public let language: Language
}

public func fetchDailyChallengeResults(
  _ conn: Conn<StatusLineOpen, FetchDailyChallengeResultsRequest>
) -> IO<Conn<HeadersOpen, Either<ApiError, FetchDailyChallengeResultsResponse>>> {

  let request = conn.data

  let results = request.database.fetchDailyChallengeResults(
    .init(
      gameMode: request.gameMode,
      gameNumber: request.gameNumber,
      language: request.language,
      playerId: request.currentPlayer.id
    )
  )

  return results
    .run
    .flatMap { errorOrResults in
      switch errorOrResults {
      case let .right(results):
        return conn.map(
          const(
            .right(
              FetchDailyChallengeResultsResponse(results: results)
            )
          )
        )
          |> writeStatus(.ok)

      case let .left(error):
        return conn.map(const(.left(ApiError(error: error))))
          |> writeStatus(.badRequest)
      }
    }
}

@MemberwiseInit(.public)
public struct DailyChallengeHistoryRequest {
  public let currentPlayer: Player
  public let database: DatabaseClient
  public let gameMode: GameMode
  public let language: Language
}

public func fetchRecentDailyChallenges(
  _ conn: Conn<StatusLineOpen, DailyChallengeHistoryRequest>
) -> IO<Conn<HeadersOpen, Either<ApiError, DailyChallengeHistoryResponse>>> {

  let request = conn.data

  let results = request.database.fetchDailyChallengeHistory(
    .init(
      gameMode: request.gameMode,
      language: request.language,
      playerId: request.currentPlayer.id
    )
  )

  return results
    .run
    .flatMap { errorOrResults in
      switch errorOrResults {
      case let .right(results):
        return conn.map(
          const(
            .right(
              DailyChallengeHistoryResponse(results: results)
            )
          )
        )
          |> writeStatus(.ok)

      case let .left(error):
        return conn.map(const(.left(ApiError(error: error))))
          |> writeStatus(.badRequest)
      }
    }
}
