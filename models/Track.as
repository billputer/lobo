package models
{
	
	[RemoteClass]
	[Bindable]
	/**
	 * The Track class contains all associated metadata contained in a Howl JSON track.
	 */
	public class Track
	{
		/** 
		 * Unique id provided by Howl.
		 */
		public var id:String = "";
		
		/**
		 * Artist who created the track.
		 */
		public var artist:String = "";
		
		/**
		 * Title of the track.
		 */
		public var title:String = "";
		
		/** 
		 * Album track is released on .
		 */
		public var album:String = "";
		
		/**
		 * Track position on album.
		 */
		public var track_number:int = 0;
		
		/**
		 * Genre of the track.
		 */
		public var genre:String = "";
		
		/**
		 * Year the track was released.
		 */
		public var year:int = 0;
		
		/**
		 * Duration of the track in seconds.
		 */
		public var duration:int = 0;
		
		/**
		 * Returns a new track given a JSON object from Howl.  The JSON object is iterated through, and each field is assigned.
		 */
		public function Track(new_track:Object=null){
			if(new_track){
				for (var key:String in new_track.track){
					if(this.hasOwnProperty(key))
						this[key] = new_track.track[key];
				}
			}	
		}
		
		/**
		 * Returns track duration formatted as a string.  For instance, if the time is 343 then the string '5:43' is returned.
		 * @return String containing formatted time.
		 */
		public function get formatted_time():String{
			var minutes:String = String(int(duration/60))
			var seconds:String = String(int(duration%60));
			if (seconds.length == 1)
				seconds = "0" + seconds; 
			return minutes+ ":" + seconds;
		}
	}
}