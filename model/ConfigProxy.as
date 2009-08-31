package com.collectivecolors.extensions.flex3.config.model
{
	//----------------------------------------------------------------------------
	// Imports
		
	import com.collectivecolors.extensions.flex3.config.ConfigFacade;
	import com.collectivecolors.extensions.flex3.config.model.data.ConfigVO;
	import com.collectivecolors.extensions.flex3.startup.model.StartupProxy;
	import com.collectivecolors.rpc.HTTPAgent;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
		
	//----------------------------------------------------------------------------
	
	public class ConfigProxy extends StartupProxy
	{
		//--------------------------------------------------------------------------
		// Constants
		
		public static const NAME : String = "configFacade_configProxy";
		
		//--------------------------------------------------------------------------
		// Constructor
				
		public function ConfigProxy( flashVars : Object = null )
		{
			super( NAME );
			
			setData( new ConfigVO(
			    flashVars[ ConfigFacade.CONFIG_PATH ],
			    flashVars[ ConfigFacade.CONFIG_FILE ]
			  ) 
			);
			
			if ( ! data.file )
			{
			  data.file = ConfigFacade.DEFAULT_CONFIG_FILE;
			}			
		}
		
		//--------------------------------------------------------------------------
		// Accessors
		
		/**
		 * Get configuration data object
		 */
		protected function get data( ) : ConfigVO
		{
		  return getData( ) as ConfigVO;
		}
		
		/**
		 * Set configuration file path
		 */
		public function set path( value : String ) : void
		{
			data.path = value;
			sendNotification( ConfigFacade.UPDATED );
		}
		
    /**
     * Set configuration file name
     */ 
    public function set file( value : String ) : void
    {
      data.file = value;
			sendNotification( ConfigFacade.UPDATED );
    }
    
		/**
		 * Get configuration url ( for downloading )
		 */
		public function get url( ) : String
		{
		  return data.url;
		}
		
    /**
     * Check whether configuration info has been initialized at startup
     */ 
    public function get initialized( ) : Boolean
    {
      return data.initialized;
    }
    
    /**
     * Get status messages from last operation
     */ 
    public function get messages( ) : Array
    {
      return data.messages;
    }
    
    /**
     * Add a new message onto the status message queue
     */ 
    public function addMessage( extension : String,
                                status : String,
                                message : String ) : void
    {
      data.addMessage( extension, status, message );
    }
    
    /**
     * Get configuration data ( XML Object )
     */ 
    public function get config( ) : XML
    {
      return data.data;
    }
    
    /**
     * Check whether or not the parsing of the configuration data was successful
     */ 
    public function get parseFailed( ) : Boolean
    {
      return data.parseFailed;
    }
    
    /**
     * Set whether or not the parsing of the configuration data was successful
     * 
     * This is useful for extensions that need to parse coonfiguration data
     * that comes in and need a way to tell the startup manager that there
     * was a problem loading the required configuration information.
     * 
     * When this flag is set during the parse notification by a command acting
     * on it, then the configuration manager triggers a failed notification
     * for the startup manager when all extensions have parsed their 
     * information.
     */ 
    public function set parseFailed( value : Boolean ) : void
    {
      data.parseFailed = value;
    }
    		
		//--------------------------------------------------------------------------
		// Overrides
		
		/**
		 * Set the value of the failed startup notification name to our constant
		 * so it is easier to listen for in our mediators.
		 * 
		 * @see StartupProxy
		 */
		final override protected function get failedNoteName( ) : String
		{
			return ConfigFacade.FAILED;
		}
		
		/**
		 * Set the value of the loaded startup notification name to our constant
		 * so it is easier to listen for in our mediators.
		 * 
		 * @see StartupProxy
		 */
		final override protected function get loadedNoteName( ) : String
		{
			return ConfigFacade.LOADED;
		}
		
		/**
		 * Request XML configuration file from server.
		 * 
		 * This method is automatically called by the StartupProxy's loadResources()
		 * method.
		 * 
		 * @see StartupProxy
		 */
		final override public function load( ) : void
		{
			data.messages    = new Array( );	
			data.parseFailed = false;	
			
			sendNotification( ConfigFacade.LOADING );
			executeRequest( data.url );
			
			data.initialized = true;				
		}
		
		//--------------------------------------------------------------------------
		// Event handlers
		
		/**
		 * Configuration file failed to load.
		 * 
		 * If you create your own event handler, be sure to call processFault( ) 
		 * with the error message.  This way we can keep the logic in the super 
		 * class.
		 * 
		 * You should only need to implement your own event handler if you have
		 * a request method that generates a error other than a FaultEvent.
		 */
		private function faultHandler( event : FaultEvent ) : void
		{
			processFault( event.fault.faultString );
		}
		
		/**
		 * Configuration loaded successfully.
		 * 
		 * If you create your own event handler, be sure to call processResult( ) 
		 * with the return value.  This way we can keep the logic in the super 
		 * class.
		 * 
		 * You should only need to implement your own event handler if you have
		 * a request method that generates an event other than a ResultEvent.
		 */
		private function resultHandler( event : ResultEvent ) : void
		{
			processResult( event.result );
		}
		
		//--------------------------------------------------------------------------
		// Internal utilities
		
		/**
		 * Execute a request for the XML configuration file.
		 */
		protected function executeRequest( url : String ) : void
		{
		  var agent : HTTPAgent = new HTTPAgent( resultHandler, faultHandler );
			
			agent.method     = HTTPAgent.METHOD_GET;
			agent.resultType = HTTPAgent.RESULT_XML_E4X;
						
			agent.request( url );	
		}
		
		/**
		 * Process configuration load failure.
		 * 
		 * This is useful for calling in custom sub class result handlers.
		 */ 
		final protected function processFault( statusMessage : String ) : void
		{
		  addMessage( 
		    ConfigFacade.NAME,
		    ConfigFacade.STATUS_ERROR, 
		    statusMessage 
		  );
			
			sendFailedNotification( );
		}
		
		/**
		 * Process the result of the configuration load.
		 * 
		 * This is useful for calling in custom sub class result handlers.
		 */ 
		final protected function processResult( result : Object ) : void
		{
		  data.data = result as XML;
		  
		  addMessage( 
		    ConfigFacade.NAME,
		    ConfigFacade.STATUS_SUCCESS, 
		    'Configuration settings downloaded successfully' 
		  );	
		  
		  // Let extensions or the application parse their own configuration data
		  sendNotification( ConfigFacade.PARSE, config );
		  
		  // Make sure that we are ok to send loaded notification?
		  if ( parseFailed )
		  {
		    addMessage(
		      ConfigFacade.NAME,
		      ConfigFacade.STATUS_ERROR,
		      'Configuration settings parse failed'
		    );
		    
		    sendFailedNotification( );
		  }
		  else
		  {
		    addMessage(
			    ConfigFacade.NAME,
			    ConfigFacade.STATUS_SUCCESS,
			    'Configuration settings loaded successfully'
			  );
			  
			  sendLoadedNotification( );
		  }
		}
	}
}