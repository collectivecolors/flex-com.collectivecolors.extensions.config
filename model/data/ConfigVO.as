package com.collectivecolors.extensions.flex3.config.model.data
{
  //----------------------------------------------------------------------------
  // Imports
  
  import com.collectivecolors.extensions.as3.data.StatusVO;
  
  //----------------------------------------------------------------------------
  
  public class ConfigVO
  {
    //--------------------------------------------------------------------------
    // Properties
    
    private var _path : String = '';    
    private var _file : String = '';
    
    public var initialized : Boolean = false;
    
    private var _messages : Array;
    private var _data : XML;
    
    public var parseFailed : Boolean = false;
    
    //--------------------------------------------------------------------------
    // Constructor
    
    public function ConfigVO( path : String = '', 
                              file : String = '' )
    {
      this.path = path;
      this.file = file;
      
      _messages = new Array( );
    }
    
    //--------------------------------------------------------------------------
    // Accessors / modifiers
    
		/**
		 * Get configuration file path
		 */
    public function get path( ) : String
    {
      return _path;
    }
    
		/**
		 * Set configuration file path
		 */
    public function set path( value : String ) : void
    {
      value = parsePath( value );			
			
			if ( value != _path )
			{
				_path = value;
			}  
    }
    
    /**
     * Get configuration file name
     */ 
    public function get file( ) : String
    {
      return _file;
    }
    
    /**
     * Set configuration file name
     */ 
    public function set file( value : String ) : void
    {
      _file = ( value != null ? value : '' );
    }
    
    /**
     * Get configuration file url ( where can we download )
     */ 
    public function get url( ) : String
    {
      return path + file;  
    }
    
    /**
     * Get status messages from last configuration load
     */ 
    public function get messages( ) : Array
    {
      return _messages;
    }
    
    /**
     * Set status messages for last configuration load
     */ 
    public function set messages( values : Array ) : void
    {
      _messages = ( values != null ? values : new Array( ) );
    }
    
    /**
     * Add a status message
     */ 
    public function addMessage( extension : String,
                                status : String, 
                                message : String ) : void
    {
      _messages.push( new StatusVO( extension, status, message ) );
    }
    
    /**
     * Get configuration data
     */ 
    public function get data( ) : XML
    {
      return _data;
    }
    
    /**
     * Set configuration data
     */ 
    public function set data( value : XML ) : void
    {
      _data = value;
    }
    
    //--------------------------------------------------------------------------
    // Internal utilities
    
		/**
		 * Check given input and parse into valid root path value
		 */
		protected function parsePath( value : String ) : String
		{
			if ( value == null )
			{
				value = '';
			}
			else if ( value.length > 0 && value.charAt( value.length - 1 ) != '/' )
			{
				value += '/';
			}
			
			return value;	
		}	
  }
}