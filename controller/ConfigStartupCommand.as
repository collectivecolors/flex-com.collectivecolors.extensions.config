package com.collectivecolors.extensions.flex3.config.controller
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.extensions.flex3.config.model.ConfigProxy;  
  
  import org.puremvc.as3.interfaces.INotification;
  import org.puremvc.as3.patterns.command.SimpleCommand;

  //----------------------------------------------------------------------------

  public class ConfigStartupCommand extends SimpleCommand
  {
    //--------------------------------------------------------------------------
    // Overrides
    
    override public function execute( note : INotification ) : void
    {
      // Load configuration information  	
      facade.registerProxy( new ConfigProxy( note.getBody( ) ) );
    }
  }
}