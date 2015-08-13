
--------------------------------
-- @module ProtocolUser
-- @extend PluginProtocol

--------------------------------
-- Check whether the user logined or not
-- @function [parent=#ProtocolUser] isLogined 
-- @param self
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- Get user ID
-- @function [parent=#ProtocolUser] getUserID 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- Check function the plugin support or not
-- @function [parent=#ProtocolUser] isFunctionSupported
-- @param self
-- @param #string name, the name of plugin
-- @return bool#bool ret (return value: bool)
        
--------------------------------
-- get pListener The callback object for user result
-- @function [parent=#ProtocolUser] getActionListener 
-- @param self
-- @return UserActionListener#UserActionListener ret (return value: anysdk.UserActionListener)
        
--------------------------------
-- User login
-- @overload self, server_id, oauthLoginServer
-- @overload self, server_id         
-- @overload self        
-- @function [parent=#ProtocolUser] login
-- @param self
-- @param #string server_id
-- @param #string oauthLoginServer

--------------------------------
-- Get plugin ID
-- @function [parent=#ProtocolUser] getPluginId 
-- @param self
-- @return string#string ret (return value: string)
        
--------------------------------
-- set the result listener
-- @function [parent=#ProtocolUser] setActionListener 
-- @param self
-- @param #function function of listener callback
        
return nil
