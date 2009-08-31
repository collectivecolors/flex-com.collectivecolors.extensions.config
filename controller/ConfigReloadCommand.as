package com.collectivecolors.extensions.flex3.config.controller
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.extensions.flex3.config.ConfigFacade;
  
  import org.puremvc.as3.interfaces.INotification;
  import org.puremvc.as3.patterns.command.SimpleCommand;

  //----------------------------------------------------------------------------

  public class ConfigReloadCommand extends SimpleCommand
  {
    //--------------------------------------------------------------------------
    // Overrides
    
    override public function execute( note : INotification ) : void
    {
      if ( ConfigFacade.configProxy.initialized )
      {
        // Reload the configuration data
        ConfigFacade.configProxy.load( );
      }  
    }    
  }
}