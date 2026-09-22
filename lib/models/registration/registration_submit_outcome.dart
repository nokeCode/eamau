/// Result of [RegistrationRepository.submitDraft], used by the UI to show a
/// message matching what actually happened (immediate online success,
/// offline queueing, queued fallback after an error, or authentication required).
enum RegistrationSubmitOutcome {
  /// The device was online and registration.create -> document uploads ->
  /// registration.submit all completed successfully before returning.
  submittedOnline,

  /// The device was offline: the draft and its documents were saved
  /// locally and the operations were queued for later sync.
  queuedOffline,

  /// The device reported being online but the immediate sync attempt did
  /// not fully complete (network error, server error, timeout...). The
  /// request was preserved locally and queued for background retry.
  queuedAfterError,

  /// The draft could not even be saved/queued locally.
  failed,

  /// The API answered with 401 (Authentification requise). The draft is
  /// preserved locally so the user can log in and resume this submission.
  requiresAuthentication,

  /// The API rejected a document upload because a registration was already
  /// submitted through this email ("Cette demande ne peut plus recevoir de
  /// document."). Permanent, not a transient error: retrying won't help —
  /// the user needs to go find their existing request instead.
  alreadySubmittedElsewhere,
}
