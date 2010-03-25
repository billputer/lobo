package controls
{
	import com.adobe.serialization.json.JSON;
	
	import models.*;
	import mx.utils.URLUtil;
	import mx.rpc.http.HTTPService;
	import mx.rpc.events.*;
	
	public class SetService
	{
		/**
		 * Private instance of HTTPService component used for sending requests.
		 */
		private var set_service:HTTPService;
		
		/**
		* Class constructor for SetService.  Initializes an HTTPService object and configures it.
		*/
		public function SetService(url:String) {
        	set_service = new HTTPService();
            set_service.method = "POST"
            set_service.headers = {'Accept':'application/json','X-Http-Method-Override':'PUT'};
            set_service.contentType = 'application/json';
            set_service.resultFormat = "text";
            set_service.addEventListener(ResultEvent.RESULT, set_service_ResultHandler);
        	set_service.addEventListener(FaultEvent.FAULT, set_service_fault_handler);
            set_service.rootURL = url;
        }
        
       	/**
        * Sends an HTTP request to the Howl server with a JSON object to update.
        * @param resource_uri URI of the resource to be updated.
        * @param json_object JSON object containing new resource information.
 		*/
        public function set_request(resource_uri:String, json_object:Object):void{
    		var json_string:String = JSON.encode(json_object);
    		trace("Sending set request with json:" + json_string);
			set_service.url = URLUtil.getFullURL(set_service.rootURL, resource_uri);
    		set_service.request = json_string;
    		set_service.send();
        }
        
       /**
        * Result handler for sucessful set requests.  Retrieves an updated status after success.
        * @param event ResultEvent of successful HTTP request.
 		*/
        private function set_service_ResultHandler(event:ResultEvent):void{
        	trace('set request successful');
        	HowlService.get_instance().get_status();
        }
		
       /**
        * Result handler for failed set requests.  Prints debugging information.
        * @param event ResultEvent of failed HTTP request.
 		*/
		private function set_service_fault_handler(event:FaultEvent):void {
			trace('Get request failed with http code: ' + event.messageId); 
		    trace('url' + HTTPService(event.target).request.toString());
    		for (var key:String in event.headers){
    			trace('\t' + key +': '+ event.headers[key]);
    		}
		}
		

	}
}