
--------------------------------
-- @module HttpClient
-- @parent_module bbns

--------------------------------
-- @function [parent=#HttpClient] sendImmediate 
-- @param self
-- @param #cc.network::HttpRequest httprequest
        
--------------------------------
-- @function [parent=#HttpClient] setTimeoutForConnect 
-- @param self
-- @param #int int
        
--------------------------------
-- @function [parent=#HttpClient] setTimeoutForRead 
-- @param self
-- @param #int int
        
--------------------------------
-- @function [parent=#HttpClient] send 
-- @param self
-- @param #cc.network::HttpRequest httprequest
        
--------------------------------
-- @function [parent=#HttpClient] enableCookies 
-- @param self
-- @param #char char
        
--------------------------------
-- @function [parent=#HttpClient] getTimeoutForConnect 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- @function [parent=#HttpClient] getTimeoutForRead 
-- @param self
-- @return int#int ret (return value: int)
        
--------------------------------
-- @function [parent=#HttpClient] destroyInstance 
-- @param self
        
--------------------------------
-- @function [parent=#HttpClient] getInstance 
-- @param self
-- @return network::HttpClient#network::HttpClient ret (return value: cc.network::HttpClient)
        
return nil
