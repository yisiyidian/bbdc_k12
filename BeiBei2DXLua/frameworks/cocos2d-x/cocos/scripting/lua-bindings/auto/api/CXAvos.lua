
--------------------------------
-- @module CXAvos
-- @extend Ref
-- @parent_module cx

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
-- @function [parent=#CXAvos] downloadFile 
-- @param self
-- @param #char objectId
-- @param #char savepath
-- @param #int nHandler
        
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
-- @function [parent=#CXAvos] downloadWordSoundFiles 
-- @param self
-- @param #char prefix
-- @param #char wordsList
-- @param #char subfix
-- @param #char path
        
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
-- 使用SMS Code登陆
-- @function [parent=#CXAvos] loginWithSMS 
-- @param self
-- @param #char phoneNumber
-- @param #char smsCode
-- @param #int mHandler
        
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
-- 验证之后的回调
-- @function [parent=#CXAvos] invokeLuaCallBackFunction_vp 
-- @param self
-- @param #char error
-- @param #int errorCode
        
--------------------------------
-- 
-- @function [parent=#CXAvos] logInByQQ 
-- @param self
-- @param #int nHandler
        
--------------------------------
-- 请求验证手机号码 服务器会给手机发送验证码
-- @function [parent=#CXAvos] requestVerifyPhoneNumber 
-- @param self
-- @param #char phoneNumber
        
--------------------------------
-- 验证短信验证码 --这干码 跟上边那个码不一样,只是用来验证手机号有效性的,上边是跟账号无关的验证
-- @function [parent=#CXAvos] verifyPhoneNumber 
-- @param self
-- @param #char phoneNumber
-- @param #char smsCode
-- @param #int mHandler
        
--------------------------------
-- 修改密码
-- @function [parent=#CXAvos] changePwd 
-- @param self
-- @param #char username
-- @param #char oldPwd
-- @param #char newPwd
-- @param #int nHandler
        
--------------------------------
-- 
-- @function [parent=#CXAvos] logInByPhoneNumber 
-- @param self
-- @param #char PhoneNumber
-- @param #char password
-- @param #int nHandler
        
--------------------------------
-- 
-- @function [parent=#CXAvos] downloadConfigFiles 
-- @param self
-- @param #char objectIds
-- @param #char path
        
--------------------------------
-- 
-- @function [parent=#CXAvos] initTencentQQ 
-- @param self
-- @param #char appId
-- @param #char appKey
        
--------------------------------
-- 用验证码登陆回调
-- @function [parent=#CXAvos] invokeLuaCallBackFunction_ls 
-- @param self
-- @param #char objectjson
-- @param #char error
-- @param #int errorcode
        
--------------------------------
-- 
-- @function [parent=#CXAvos] signUp 
-- @param self
-- @param #char username
-- @param #char password
-- @param #int nHandler
        
--------------------------------
-- 修改密码完成的回调
-- @function [parent=#CXAvos] invokeLuaCallbackFunction_cp 
-- @param self
-- @param #char error
-- @param #int errorcode
        
--------------------------------
-- 
-- @function [parent=#CXAvos] logOut 
-- @param self
        
--------------------------------
-- 获取手机登陆的验证码
-- @function [parent=#CXAvos] requestLoginSMS 
-- @param self
-- @param #char phoneNumber
        
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
