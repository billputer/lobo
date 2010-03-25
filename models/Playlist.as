package models
{
	import mx.collections.ArrayCollection;
	[Bindable]
	/**
	 * The Playlist class is a container class for all information related to a Howl playlist.
	 * This class extends ArrayCollection, a class from the mx.collections package.  ArrayCollection is a wrapper around Array that allows it to function as a dataProvider for visual components such as mx:List and mx:DataGrid, thus ensuring that changes to the Playlist propogate back to the view.  
	 * ArrayCollection also provides functions related to filtering and ordering.
	 */
	public class Playlist extends ArrayCollection
	{
		/** 
		 * Name of the playlist.
		 */
        public var name:String = "";
        
        /** 
        * Relative URI where the playlist can be accessed.
        */
        public var uri:String = "";
        
        /**
        * Value determining whether playlist is repeated during playback.
        */
        public var repeat:Boolean = false;
        
        /** 
        * Value determining whether song selection is done in random order.
        */
		public var random:Boolean = false;
		
		/** 
		 * Search string to filter which items in a playlist are displayed. 
		 */
		public var search_string:String = "";

        /**
        * Function for loading new data into a Playlist object.  This is generally used instead of creating and destroying Playlist objects.
        */
        public function set_playlist(json_object:Object):void{
        	/**Because we are updating an entire list, it is much faster to push the new tracks
        	 * into an array and then change the tracks all at once.  Otherwise, each newly added
        	 * will trigger a ChangeEvent, propogating each addition down to the view.
        	 */
        	var arr:Array = [];
			for each(var o:Object in json_object.playlist["tracks"]){
				arr.push(new Track(o));
			}
			this.removeAll();
			this.source = arr;
			
			this.name = json_object.playlist.name;
			this.uri = json_object.playlist.uri;
			
			
        }
       	/**
	 	 * Search function used to see if playlist contains a certain track.
	 	 * @param track_to_find Track to look for.
		 */ 
       	public function index_by_id(track_to_find:Track):int{
			for(var x:int = 0; x < this.length; x++){
				if(track_to_find.id == Track(this.getItemAt(x)).id){
					return x;
				}
			}
			return -1;
		}
        
        /**
	 	 * Search function used to filter Tracks.  If function returns true, then Track is displayed. 
	 	 * @param song Track whose fields are searched.
		 */ 
       	public function search_function(song:Track):Boolean{
			for each (var str:String in ["artist","title","album","id","genre"]){
				if(song[str].toUpperCase().search(search_string.toUpperCase()) != -1){
					return true;
				}
			}
			return false;
		}

	}
}