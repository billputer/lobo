package models
{
	import mx.collections.ArrayCollection;
	
	[Bindable]
	/**
	* The DataModel class fulfills the Model portion of the Model/View/Controller pattern.
	* It functions as a container class for different portions of the Lobo application.
	* The DataModel class also implements the Singleton pattern, providing a single static instance.
	* 
	*/
	public class DataModel
	{
		/** 
		 * Singleton instance of DataModel class.
		 * */
        private static var _instance:DataModel = null;
        
        /** 
        * Names of all Howl playlists. 
        **/
        public var playlist_names:ArrayCollection;
        
        /** 
        * All Howl playlists.
        */
        public var playlists:ArrayCollection;
        
        /** 
        * Currently displayed Howl playlist. 
        **/
        public var current_playlist:Playlist; 
        
        /** 
        * Temporary user playlist in Lobo.  
        **/
        public var temp_playlist:Playlist;
         
        /** 
        * Status object containing player state.
        **/
        public var status:Status;
        
        /** 
        * Audio output, can either be browser or howl 
        **/
        public var output:String = 'howl';
        
        /**
        * Class constructor for DataModel which initializes all playlist and status objects.  Should only be called in the get_instance() method to preserve singleton status.
 		*/
        public function DataModel() {
        	playlist_names = new ArrayCollection();
        	playlists = new ArrayCollection();
       		current_playlist = new Playlist();
       		current_playlist.filterFunction = current_playlist.search_function;
       		temp_playlist = new Playlist();
       		status = new Status();
       	}
       	/**
        *  Generates an instance of DataModel if there is none, otherwise retrieves singleton instance of DataModel.
 		*/
        public static function get_instance():DataModel { 
            if(_instance == null) { 
                _instance = new DataModel(); 
            }
            return _instance; 
        }
	}
}
