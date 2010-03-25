package models
{
	import flash.utils.setInterval;
	import flash.utils.clearInterval;
	
	import controls.Controller;
	
	[Bindable]
	/**
	 * The Status class contains information about the current player state.  
	 * This information pertains to either the Howl server or the Lobo client,
	 * depending on which is selected as an output. 
	 */
	public class Status
	{
		/** 
		 * Unique identifier used to keep track of the timer that updates current position every second.
		 */
		private var timer_id:uint;
		
		/** 
		 * Currently playing track.  Indicates no current track when set to a Track object with empty fields.
		 */
		public var current_track:Track;
		
		/** 
		 * Currently player state, either "stopped", "paused", or "playing".
		 */
		public var state:String;
		
		/**
		 * Current player position.
		 */
		public var position:int;
		
		/**
		 * Current player volume, an integer between 0 and 100.
		 */
		public var volume:int;
		
		/**
		 * Status constructor which provides defaults for player status.
		 */
		public function Status(){
			current_track = new Track();
			state = 'stopped';
			position = 0;
			volume = 100;
		}
		
		/**
		 * Retrieves the index of the current track in temp_playlist.
		 */
		public function get current_track_index():int{
			trace(this.current_track);
			return DataModel.get_instance().temp_playlist.getItemIndex(this.current_track);
		}
		
		/**
		 * Uses the setInterval utility function to run the 'tick' function once every second.
		 */
		public function start_timer():void{
			if(timer_id == 0)
				timer_id = setInterval(tick,1000);
		}
		/**
		 * Uses the clearInterval utility function to clear the timer function.
		 */
		public function stop_timer():void{
			if(timer_id)
				clearInterval(timer_id);
			timer_id = 0;
		}
		/**
		 * Increments position and indicates to the controller when it is necessary to change tracks.
		 */
		private function tick():void 
        {
            position++;
            if(current_track.duration > 0 && position >= (current_track.duration - 1)){
            	Controller.get_instance().next();
            }
        }
        
		
	}
}