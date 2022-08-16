abstract class AuctionStates {}

class AuctionInitialState extends AuctionStates {}

class AuctionGetUserLoadingState extends AuctionStates {}

class AuctionGetUserSuccessState extends AuctionStates {}

class AuctionGetUserErrorState extends AuctionStates {
  final String error;

  AuctionGetUserErrorState(this.error);
}

class AuctionChangeBottomNavState extends AuctionStates {}

class AuctionNewPostState extends AuctionStates {}

class AuctionUserUpdateLoadingState extends AuctionStates {}

class AuctionProfileImagePickedSuccessState extends AuctionStates {}

class AuctionProfileImagePickedErrorState extends AuctionStates {}

class AuctionUploadProfileImageSuccessState extends AuctionStates {}

class AuctionUploadProfileImageErrorState extends AuctionStates {}

class AuctionUserUpdateErrorState extends AuctionStates {}

//post

class AuctionStartPostUpdateUpdateErrorState extends AuctionStates {}

class AuctionPostImagePickedSuccessState extends AuctionStates {}

class AuctionPostImagePickedErrorState extends AuctionStates {}

class AuctionRemovePostImageState extends AuctionStates {}

class AuctionCreatePostLoadingState extends AuctionStates {}

class AuctionCreatePostSuccessState extends AuctionStates {}

class AuctionCreatePostErrorState extends AuctionStates {}

class AuctionGetPostLoadingState extends AuctionStates {}

class AuctionGetPostSuccessState extends AuctionStates {}

class AuctionGetPostErrorState extends AuctionStates {
  final String error;

  AuctionGetPostErrorState(this.error);
}

class AuctionLikePostSuccessState extends AuctionStates {}

class AuctionLikePostErrorState extends AuctionStates {
  final String error;

  AuctionLikePostErrorState(this.error);
}

class AuctionWriteCommentLoadingState extends AuctionStates {}

class AuctionWriteCommentSuccessState extends AuctionStates {}

class AuctionWriteCommentErrorState extends AuctionStates {}

class AuctionGetCommentLoadingState extends AuctionStates {}

class AuctionGetCommentSuccessState extends AuctionStates {}

class AuctionGetCommentErrorState extends AuctionStates {
  final String error;

  AuctionGetCommentErrorState(this.error);
}

class AuctionTicketImagePickedSuccessState extends AuctionStates {}

class AuctionTicketImagePickedErrorState extends AuctionStates {}

class AuctionRemoveTicketImageState extends AuctionStates {}

class AuctionCreateTicketLoadingState extends AuctionStates {}

class AuctionCreateTicketSuccessState extends AuctionStates {}

class AuctionCreateTicketErrorState extends AuctionStates {}

class AuctionGetTicketLoadingState extends AuctionStates {}

class AuctionGetTicketSuccessState extends AuctionStates {}

class AuctionGetTicketErrorState extends AuctionStates {
  final String error;

  AuctionGetTicketErrorState(this.error);
}

class AuctionLikeTicketSuccessState extends AuctionStates {}

class AuctionLikeTicketErrorState extends AuctionStates {
  final String error;

  AuctionLikeTicketErrorState(this.error);
}

class AuctionTradeItemImagePickedSuccessState extends AuctionStates {}

class AuctionTradeItemImagePickedErrorState extends AuctionStates {}

class AuctionRemoveTradeItemImageState extends AuctionStates {}

class AuctionCreateTradeItemLoadingState extends AuctionStates {}

class AuctionCreateTradeItemSuccessState extends AuctionStates {}

class AuctionCreateTradeItemErrorState extends AuctionStates {}

class AuctionGetTradeItemLoadingState extends AuctionStates {}

class AuctionGetTradeItemSuccessState extends AuctionStates {}

class AuctionGetTradeItemErrorState extends AuctionStates {
  final String error;

  AuctionGetTradeItemErrorState(this.error);
}

class AuctionLikeTradeItemSuccessState extends AuctionStates {}

class AuctionLikeTradeItemErrorState extends AuctionStates {
  final String error;

  AuctionLikeTradeItemErrorState(this.error);
}

class AuctionGetSearchLoadingState extends AuctionStates {}

class AuctionGetSearchSuccessState extends AuctionStates {}

class AuctionGetSearchErrorState extends AuctionStates {
  final String error;

  AuctionGetSearchErrorState(this.error);
}

class AuctionWritePricesLoadingState extends AuctionStates {}

class AuctionWritePricesSuccessState extends AuctionStates {}

class AuctionWritePricesErrorState extends AuctionStates {}

class AuctionGetPricesLoadingState extends AuctionStates {}

class AuctionGetPricesSuccessState extends AuctionStates {}

class AuctionGetPricesErrorState extends AuctionStates {
  final String error;

  AuctionGetPricesErrorState(this.error);
}

class AuctionMakeAnOfferImagePickedSuccessState extends AuctionStates {}

class AuctionMakeAnOfferImagePickedErrorState extends AuctionStates {}

class AuctionMakeAnOfferImageState extends AuctionStates {}

class AuctionMakeAnOfferLoadingState extends AuctionStates {}

class AuctionMakeAnOfferSuccessState extends AuctionStates {}

class AuctionMakeAnOfferErrorState extends AuctionStates {}

class AuctionUploadofferImageSuccessState extends AuctionStates {}

class AuctionUploadofferImageErrorState extends AuctionStates {}

class AuctionReportPostSuccessState extends AuctionStates {}

class AuctionReportPostErrorState extends AuctionStates {}
