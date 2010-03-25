package controls
{
	
	import lib.flexpasta.utils.HTTPUtil;
	
	import models.DataModel;
	import models.Status;
	import models.Track;
	
	import flash.utils.setInterval;
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;
	import mx.utils.URLUtil;
	
	public class HowlService
	{
		/** 
		 * Singleton instance of HowlService class. 
		 */
		private static var _instance:HowlService = null;

		/** 
		 * Instance of GetService used for all GET requests.
		 */
		private var get_service:GetService;
		
		/** 
		 * Instance of SetService used for all PUT requests.
		 */
		private var set_service:SetService;
		
		/** 
		 * Instance of Mp3PlayerService used to request and play MP3s.
		 */
		private var mp3_player:Mp3PlayerService;
		
		/**
        * Class constructor for HowlService.  Should only be called in the get_instance() method to preserve singleton status.
 		*/
		public function HowlService() {
			var root_url:String = 'http://' + URLUtil.getServerNameWithPort(HTTPUtil.getUrl());
			/** initializes http services */
			get_service = new GetService(root_url);
			set_service = new SetService(root_url);
			mp3_player = new Mp3PlayerService(root_url);
			
			/** requests list of playlists */
			get_service.get_request('player/playlists');
			/** sets initial state to stopped */
			this.get_status();
			/** polls Howl every 30 seconds */
			setInterval(get_status, 30000);
			/** triggers 'output_change' on changes to 'output' variable */
			ChangeWatcher.watch(DataModel.get_instance(), "output", output_change);
		}
		
	   /**
        * Triggers the proper update, depending on which output is selected.
        * @param changed JSON object containing keys which need to be updated.
 		*/
		public function update(changed:Object):void{
			if(DataModel.get_instance().output == 'browser'){
				this.update_browser(changed);
			}else if(DataModel.get_instance().output == 'howl'){
				this.update_howl(changed);	
			}
		}
		
	  /**
        * Updates mp3's playing in browser by reading in keys and updating values.
        * @param changed JSON object containing keys which need to be updated.
 		*/
		public function update_browser(changed:Object):void{
			if(changed.hasOwnProperty('current_track')){
				mp3_player.load_new_track();
			}else if(changed.hasOwnProperty('state') || changed.hasOwnProperty('position')){
				mp3_player.update_state();
			}
			if(changed.hasOwnProperty('volume')){
				mp3_player.update_volume();
			}
		}
		
	  /**
        * Triggers an HTTP request to Howl server with updated status.
        * @param changed JSON object containing keys which need to be updated.
 		*/
		public function update_howl(changed:Object):void{
			var new_status:Object = {"status":{}};
			if(changed.hasOwnProperty('current_track') && DataModel.get_instance().status.current_track.id != ""){
				new_status.status['current_track_id'] = DataModel.get_instance().status.current_track.id;
			}
			if(changed.hasOwnProperty('state')){
				new_status.status['state'] = DataModel.get_instance().status.state;
			}
			if(changed.hasOwnProperty('position')){
				new_status.status['position'] = DataModel.get_instance().status.position;
			}
			if(changed.hasOwnProperty('volume')){
				new_status.status['volume'] = DataModel.get_instance().status.volume;
			}
			set_service.set_request('player/status/',new_status);
		}
		
	  /**
        * Modifies current status on output selection change.
        * @param event PropertyChangeEvent triggered by change in output.
 		*/
		private function output_change(event:PropertyChangeEvent):void{
			var status:Status = DataModel.get_instance().status;
			if(DataModel.get_instance().output == 'howl'){
				mp3_player.stop_playback();
				this.get_status();
			}else if(DataModel.get_instance().output == 'browser'){
				status.state = "stopped";
				status.current_track = new Track();
				status.position = 0;
			}	
		}
		
	  /**
        * Triggers an HTTP request for a playlist based on URI.
        * @param uri URI of the requested playlist.
 		*/
		public function get_playlist(uri:String):void{
			get_service.get_request(uri);
		}
		
	  /**
        * Triggers an HTTP request for an updated status.
 		*/
		public function get_status():void{
			get_service.get_request('player/status/');
		}
		
	  /**
        * Used instead of class constructor to ensure that only a single instance exists at any one time.
        * @return A static instance of HowlService
 		*/
		public static function get_instance():HowlService { 
            if(_instance == null) { 
                _instance = new HowlService(); 
            }
            return _instance; 
        }
		

    }
	
}