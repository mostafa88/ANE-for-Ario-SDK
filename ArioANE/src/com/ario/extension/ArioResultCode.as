package com.ario.extension {
	public class ArioResultCode {
		
		
		public static const RESULT_OK:int = 0; // success
		public static const RESULT_USER_CANCELED:int = 1; // user pressed back or canceled a dialog
		public static const RESULT_SERVICE_UNAVAILABLE:int = 2; // service unavailable
		public static const RESULT_BILLING_UNAVAILABLE:int = 3;// this billing API version is not supported for the type requested
		public static const RESULT_ITEM_UNAVAILABLE:int = 4;// requested SKU is not available for purchase
		public static const RESULT_DEVELOPER_ERROR:int = 5;// invalid arguments provided to the API
		public static const RESULT_ERROR:int = 6;// Fatal error during the API action
		public static const RESULT_ITEM_ALREADY_OWNED:int = 7;// Failure to purchase since item is already owned
		public static const RESULT_ITEM_NOT_OWNED:int = 8; // Failure to consume since item is not owned
		
		public static const RESULT_VERIFICATION_FAILED:int = 9;// Invalid public key
		public static const RESULT_INVALID_CONSUMPTION:int = 10; // Consume an already consumed item or no item to consume
		public static const RESULT_GAME_NOT_OWNED:int = 11 ; // User have not owned the game
		public static const RESULT_SERVICE_NOT_SUPPORTED:int = 12; // The service not support in this version of Ario, need to update Ario!
		// for example game want to use leaderboard service but leaderboard not available in current version of ario!
		public static const RESULT_GAME_NOT_RUN_FROM_ARIO:int = 13; // if user is not logged in Ario.
		
		// leaderboard result code
		public static const RESULT_NO_LEADERBOARD:int = 100;
		public static const RESULT_FRAUD_LIMIT_EXCEED:int = 101;
		
		// achievement result code
		public static const RESULT_NO_ACHIEVEMENT:int = 200;
		public static const RESULT_INACTIVE_ACHIEVEMENT:int = 201;
		public static const RESULT_ACHIEVEMENT_ALREADY_UNLOCKED:int = 202;
		
	}
}
