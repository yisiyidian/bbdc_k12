
--------------------------------
-- @module CXAvos
-- @extend Ref
-- @parent_module cx

--------------------------------
-- 
-- @function [parent=#CXAvos] logInByQQAuthData 
-- @param self
-- @param #char openid
-- @param #char access_token
-- @param #char expires_in
-- @param #int nHandler
        
--------------------------------
-- 
-- @function [parent=#CXAvos] invokeLuaCallbackFunction_dl 
-- @param self
-- @param #char objectId
-- @param #char filename
-- @param #char error
-- @param #bool isSaved
        
--------------------------------
-- 
-- @function [parent=#CXAvos] invokeLuaCallbackFunction_su 
-- @param self
-- @param #char objectjson
-- @param #char error
-- @param #int errorcode
        
--------------------------------
-- 请求短信验证码
-- @function [parent=#CXAvos] requestSMSCode 
-- @param self
-- @param #char phoneNumber
        
--------------------------------
-- 验证短信验证码
-- @function [parent=#CXAvos] verifySMSCode 
-- @param self
-- @param #char phoneNumber
-- @param #char smsCode
-- @param #int mHandler
        
--------------------------------
-- 
-- @function [parent=#CXAvos] signUp 
-- @param self
-- @param #char username
-- @param #char password
-- @param #int nHandler
        
--------------------------------
-- 
-- @function [parent=#CXAvos] downloadFile 
-- @param self
-- @param #char objectId
-- @param #char savepath
-- @param #int nHandler
        
--------------------------------
-- 
-- @function [parent=#CXAvos] logInByQQ 
-- @param self
-- @param #int nHandler
        
--------------------------------
-- 
-- @function [parent=#CXAvos] downloadWordSoundFiles 
-- @param self
-- @param #char prefix
-- @param #char wordsList
-- @param #char subfix
-- @param #char path
        
--------------------------------
-- 
-- @function [parent=#CXAvos] downloadConfigFiles 
-- @param self
-- @param #char objectIds
-- @param #char path
        
--------------------------------
-- 
-- @function [parent=#CXAvos] logOut 
-- @param self
        
--------------------------------
-- 
-- @function [parent=#CXAvos] logIn 
-- @param self
-- @param #char username
-- @param #char password
-- @param #int nHandler
        
--------------------------------
-- 
-- @function [parent=#CXAvos] invokeLuaCallbackFunction_li 
-- @param self
-- @param #char objectjson
-- @param #char error
-- @param #int errorcode
        
--------------------------------
-- 
-- @function [parent=#CXAvos] invokeLuaCallbackFunction_logInByQQ 
-- @param self
-- @param #char objectjson
-- @param #char qqjson
-- @param #char authjson
-- @param #char error
-- @param #int errorcode
        
--------------------------------
-- 
-- @function [parent=#CXAvos] initTencentQQ 
-- @param self
-- @param #char appId
-- @param #char appKey
        
--------------------------------
-- 验证之后的回调
-- @function [parent=#CXAvos] invokeLuaCallBackFunction_vc 
-- @param self
-- @param #char error
-- @param #int errorCode
        
--------------------------------
-- 
-- @function [parent=#CXAvos] getInstance 
-- @param self
-- @return CXAvos#CXAvos ret (return value: CXAvos)
        
return nil
