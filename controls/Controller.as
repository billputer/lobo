package controls
{	
 	import models.*;
	
	/**
	 *	Controller is the centralized request handling class in Howl.
	 *  User input in the view trigger methods in the controller, which then acts upon the model.
	*/
	public class Controller
	{
		/** 
		 * singleton instance of Controller class 
		 * */
		private static var _instance:Controller = null;
		
		/** 
		 * Reference to status attribute of global DataModel instance.
		 **/
		private var status:Status;
		
		/** 
		 * Reference to temp_playlist attribute of global DataModel instance.
		 **/
		private var temp_playlist:Playlist;
		
		/** 
		 * Reference to singleton instance of HowlService.
		 **/
		private var howl_service:HowlService;
		
		/**
	 	 *	Constructor for Controller class.
	 	 *  Should only ever be called by the get_instance method.
		 */
		public function Controller()
		{
			status = DataModel.get_instance().status;
			temp_playlist = DataModel.get_instance().temp_playlist;
			howl_service = HowlService.get_instance();
		}
		
		/**
	 	 *	Plays the previous item in the playlist.
		 */
		public function previous():void{
			var current_index:int = status.current_track_index;
			if(current_index > 0){
				status.current_track = temp_playlist[current_index - 1];
				status.position = 0;
			}
			howl_service.update({'current_track':true,'position':true});
		}
		
		/**
	 	 *	Play/Pause the currently playing track.
		 */
		public function play_pause():void{
			var fields_to_update:Object = {'state':true};
			
			if(status.state == "stopped" || status.state == "paused"){
				if(status.current_track.id == "" && temp_playlist.length > 0){
					status.current_track = temp_playlist[0];
					status.position = 0;
					fields_to_update['current_track'] = true;
					fields_to_update['position'] = true;
				}
				if(status.current_track.id != ""){
					status.state = "playing";	
				}
			}else{
				status.state = "paused";
			}
			howl_service.update(fields_to_update);
		}
		
		/**
	 	 *	Stops playback.
		 */
		public function stop():void{
			status.state = "stopped";
			status.current_track = new Track();
			status.position = 0;
			howl_service.update({'state':true});			
		}
		
		/**
	 	 *	Plays next track in playlist.
		 */
		public function next():void{var current_index:int = status.current_track_index;
			if(temp_playlist.length > 0 && current_index == -1){
				status.current_track = temp_playlist[0];
			}
			else{
				if(temp_playlist.random){
					var new_index:int = int(Math.random() * (temp_playlist.length -1));
					status.current_track = temp_playlist[new_index];
				}
				else{
					if(current_index >= temp_playlist.length - 1 && !temp_playlist.repeat)
						this.stop();
					else if(current_index == temp_playlist.length -1 && temp_playlist.repeat)
						status.current_track = temp_playlist[0];
					else
						status.current_track = temp_playlist[current_index + 1];					
				}
			}
			status.position = 0;
			howl_service.update({'current_track':true,'position':true});
		}
		
		/**
	 	 * Plays new song.
	 	 * @param song New song to be played
		 */ 
		public function play_song(song:Track):void{
			if(song != status.current_track)
				status.position = 0;
			status.current_track = song;
			status.state = "playing";
			howl_service.update({'state':true,'current_track':true,'position':true});
		}
		/**
	 	 * Sets new song position
	 	 * @param new_position new position in current track
		 */ 
		public function set_position(new_position:int):void{
			if(new_position >= 0 && new_position < status.current_track.duration)
				status.position = new_position;
				howl_service.update({'position':true});
		}
		/**
	 	 * Sets new volume.
	 	 * @param volume New volume
		 */ 
        public function set_volume(volume:int):void{
        	status.volume = volume;
        	howl_service.update({'volume':true});
        }
		/**
	 	 * Sets new playlist.
	 	 * @param name New playlist to be displayed
		 */ 
        public function set_playlist(index:int):void{
        	var uri:String = Playlist(DataModel.get_instance().playlists.getItemAt(index)).uri;
        	howl_service.get_playlist(uri);
        }
        /**
	 	 * Searchs current playlist for a specified string.  Displays only Tracks containing that string in specified fields. 
	 	 * @param name String to search for.
		 */ 
        public function search_playlist(search_string:String):void{
        	DataModel.get_instance().current_playlist.search_string = search_string;
        	DataModel.get_instance().current_playlist.refresh();
        }
        /**
	 	 * Clears temp playlist.
		 */ 
        public function clear_playlist():void{
        	temp_playlist.removeAll();
        }
		/**
	 	 * Static method which allows access to singleton instance of Controller
	 	 * 
	 	 * @return Static instance of Controller
		 */ 
		public static function get_instance():Controller { 
            if(_instance == null) { 
                _instance = new Controller(); 
            }
            return _instance; 
        }
		
	}
}