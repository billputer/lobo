package lib.flexpasta.utils
{
	import flash.external.ExternalInterface;
	import mx.core.Application;
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	
	
	public class HTTPUtil
	{
		//--------------------------------------------------------------------------
	    //
	    //  Constructor
	    //
	    //--------------------------------------------------------------------------
	    /**
	     *  @private
	     */
	    public function HTTPUtil()
	    {
	        super();
	    }
	    
	    /**
	    * Returns the current url that the swf player lives in
	    * 
	    */
	    public static function getUrl():String
	    {
	    	return ExternalInterface.call("window.location.href.toString");
	    }
	    
	    /**
	    * Returns the current host name. 
	    * example: http://www.flexpasta.com/?x=1&y=2 would return www.flexpasta.com
	    */ 
	    public static function getHostName():String
	    {
	    	return ExternalInterface.call("window.location.hostname.toString");
	    }
	    
	    /**
	    * Returns the current protocol, such as http:, https:, etc
	    * 
	    */
	    public static function getProtocol():String
	    {
	    	return ExternalInterface.call("window.location.protocol.toString");
	    } 
	    
	    /**
	    * Gets the current port for the url
	    */ 
	    public static function getPort():String
	    {
	    	return ExternalInterface.call("window.location.port.toString");
	    }
	    
	    /**
	    * Gets the context following the base of the url
	    * Example http://www.flexpasta.com/test?x=1&y=2 would return /test
	    */ 
	    public static function getContext():String
	    {
	    	return ExternalInterface.call("window.location.pathname.toString");
	    }
	    
	    
	    /**
	    * Gets a url parameter value by name and returns it as a String.  This function works without flash vars being passed into the swf.
	    * For example, even if the url is something like, domain.com?MyFlexPage.html?b=5, it will still return 5 when 'b' is passed.
	    * The function uses javascript to find the url paramters.  Please note however that this will only work for a GET request and not a POST.
	    */ 
	    public static function getParameterValue(key:String):String
	    { 
	    	var value:String;
	    	var uparam:String = ExternalInterface.call("window.location.search.toString");
	    	
	    	if(uparam==null)
	    	{
		    	return null;
		    }
		    var paramArray:ArrayCollection = new ArrayCollection(uparam.split('&'));
		    for(var x:int=0; x<paramArray.length; x++)
		    {
		    	var p:String = paramArray.getItemAt(x) as String;
		    	if(p.indexOf(key + '=')>-1)
		    	{
		    		value = (p.replace((key + '='), '')).replace('?','');
		    		x=paramArray.length;
		    	}
		    }
		    
		    return value;
	    }
	}
}