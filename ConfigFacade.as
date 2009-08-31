package com.collectivecolors.extensions.flex3.config
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.emvc.patterns.extension.Extension;
  import com.collectivecolors.extensions.as3.data.StatusVO;
  import com.collectivecolors.extensions.flex3.config.controller.ConfigReloadCommand;
  import com.collectivecolors.extensions.flex3.config.controller.ConfigStartupCommand;
  import com.collectivecolors.extensions.flex3.config.model.ConfigProxy;
  import com.collectivecolors.extensions.flex3.startup.StartupFacade;  

  //----------------------------------------------------------------------------

  public class ConfigFacade extends Extension
  {
    //--------------------------------------------------------------------------
    // Constants
    
    public static const NAME : String = "configFacade";
    
    //----------------
    // Notifications
    
    public static const UPDATED : String = "configFacadeUpdated";
    public static const LOAD : String    = "configFacadeLoad"; 
    		
		public static const LOADING : String = "configFacadeLoading";
		public static const LOADED : String  = "configFacadeLoaded";
		public static const FAILED : String  = "configFacadeFailed";
		
		public static const PARSE : String = "configFacadeParse";
		
		//------------    
    // FlashVars
    
    public static const CONFIG_PATH : String = "configPath";
    public static const CONFIG_FILE : String = "configFile";    
    
		//-------
		// Misc
		
		// Change this filename to something more secure.
		public static const DEFAULT_CONFIG_FILE : String = "config.xml";
		
		// Status types ( for message queue )
		
		public static const STATUS_SUCCESS : String = StatusVO.SUCCESS;
		public static const STATUS_NOTICE : String  = StatusVO.NOTICE;
		public static const STATUS_ERROR : String   = StatusVO.ERROR;
		
    //--------------------------------------------------------------------------
    // Constructor
    
    public function ConfigFacade( )
    {
      super( NAME );
    }
    
    //--------------------------------------------------------------------------
    // Overrides
    
    override public function onRegister( ) : void
    {
      if ( ! core.hasExtension( StartupFacade.NAME ) )
      {
        core.registerExtension( new StartupFacade( ) );
      }  
    }
    
    //--------------------------------------------------------------------------
    // Accessors
    
    public static function get configProxy( ) : ConfigProxy
    {
      return core.retrieveProxy( ConfigProxy.NAME ) as ConfigProxy;
    }
    
    //--------------------------------------------------------------------------
    // eMVC hooks
    
    public function initializeController( ) : void
    {
      core.registerCommand( StartupFacade.REGISTER_RESOURCES, ConfigStartupCommand );
      core.registerCommand( UPDATED, ConfigReloadCommand );
      core.registerCommand( LOAD, ConfigReloadCommand );
    }    
  }
}