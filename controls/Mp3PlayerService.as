package controls
{
	import models.DataModel;
	
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import mx.utils.URLUtil;
	import mx.events.PropertyChangeEvent;
	
	public class Mp3PlayerService
	{
		/**
		 * Base URL for making requests.
		 */
		private var rootURL:String;
		
		/**
		 * Sound object for downloaded MP3 file.
		 */
		private var sound_file:Sound;
		
		/**
		 * Unique ID of downloaded sound_file.  Used to check if it's necessary to download a new sound_file.
		 */ 
		private var sound_file_id:String;
		
		/**
		 * SoundLoaderContext object for manipulating volume.
		 */
		private var context:SoundLoaderContext;
		
		/**
		 * SoundChannel object over which all sounds are played.
		 */
        private var soundChannel:SoundChannel;
		
		/**
		* Class constructor for Mp3PlayerService.  Initializes Sound and SoundLoaderContext objects.
		*/
		public function Mp3PlayerService(url:String)
		{
			rootURL = URLUtil.getFullURL(url,'player/tracks/');
			sound_file = new Sound();
            context = new SoundLoaderContext(5000, true);
		}
		
		/**
		 * Initiates a request for a new MP3 file.  Updates sound_file_id and inits a new Sound object.  
		 */
		public function load_new_track():void{
			try {
				if(soundChannel)
					soundChannel.stop();
            	sound_file.close();
			}catch (error:IOError) {}
			
			if(DataModel.get_instance().status.current_track.id != ""){
				sound_file_id = DataModel.get_instance().status.current_track.id;
				trace('loading new track');
				sound_file = new Sound();
	            sound_file.addEventListener(Event.COMPLETE, sound_loaded_handler);
	            sound_file.addEventListener(IOErrorEvent.IO_ERROR, io_error_handler);
	            sound_file.load(new URLRequest(rootURL + sound_file_id + '/file/'), context);
	            DataModel.get_instance().status.stop_timer();
			}else{
				sound_file_id = "";
			}
		}
		
		/**
		 * Stops all sound playback.
		 */
		public function stop_playback():void{
			DataModel.get_instance().status.stop_timer();
			if(soundChannel != null)  
				soundChannel.stop();
		}
		
		/**
		 * Updates state of player based on the global Status state attribute.
		 */
		public function update_state():void{
			if(DataModel.get_instance().status.state == 'playing' && DataModel.get_instance().status.current_track.id != ""){
				if(soundChannel)
					soundChannel.stop();
				var sndTransform:SoundTransform = new SoundTransform(Number(DataModel.get_instance().status.volume) / 100);
	            soundChannel = sound_file.play(Number(DataModel.get_instance().status.position * 1000), 0 ,sndTransform );
	            DataModel.get_instance().status.start_timer();
			}else{
				DataModel.get_instance().status.stop_timer();
				if(soundChannel != null)  
	                soundChannel.stop();
			}
			
		}
		
		/**
		 * Updates volume of currently playing track.
		 */	
		public function update_volume():void{
			if(soundChannel){
				var transform:SoundTransform = soundChannel.soundTransform;
        		transform.volume = Number(DataModel.get_instance().status.volume) / 100;
				soundChannel.soundTransform = transform;
			}
		}

		/**
		 * Handler for successful file load.  Sends debug info and triggers state update.
		 * @param event Successful load event.
		 */
		private function sound_loaded_handler(event:Event):void
		{
			trace('new track loaded');
			update_state();
    	
		}
		
		/**
		 * Handler for failed file load.  Sends debug info and triggers state update.
		 * @param event Failed load event.
		 */
		private function io_error_handler(event:IOErrorEvent):void
		{
		    trace("Failed to load mp3: " + event.text);
		    this.load_new_track()
		}
				
		

	}
}