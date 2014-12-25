package c.bb.dc.sns;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.os.SystemClock;
import android.util.Log;

import c.bb.dc.BBNDK;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVUser;
import com.avos.avoscloud.LogInCallback;
import com.avos.sns.*;
import com.tencent.connect.UserInfo;
import com.tencent.connect.common.Constants;
import com.tencent.open.utils.HttpUtils.HttpStatusException;
import com.tencent.open.utils.HttpUtils.NetworkUnavailableException;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;

//TODO : just log in
public class CXTencentSDKCall {
	private static CXTencentSDKCall mInstance = null;
	
	private Tencent mTencent = null;
	private Activity mActivity = null;
	private JSONObject mAuthData = null;
	
	public static CXTencentSDKCall getInstance() {
		if (mInstance == null) {
			mInstance = new CXTencentSDKCall();
		}
		return mInstance;
	}
	
	public void init(String appId, Activity activity) {
		mActivity = activity;
		mTencent = Tencent.createInstance(appId, activity);
	}
	
	public void logIn() {
		if (!mTencent.isSessionValid()) {
			mTencent.login(mActivity, "all", new LogInListener());
		}
	}

	public void logInByAuthData(String access_token, String expires_in, final Object response) {
		AVUser.AVThirdPartyUserAuth userAuth = new AVUser.AVThirdPartyUserAuth(access_token, expires_in, "qq", null);
		AVUser.loginWithAuthData(userAuth, new LogInCallback<AVUser>() {
			public void done(AVUser user, AVException e) {
		        if (e == null) {
		        	BBNDK.onLogInByQQ(
		        			BBNDK.AVUserToJsonStr(user), 
		        			response != null ? response.toString() : null, 
		        			mAuthData != null ? mAuthData.toString() : null, 
		        			null, 
		        			0);
		        } else {
		        	BBNDK.onLogInByQQ(null, null, null, e.getLocalizedMessage(), e.getCode());
		        }
		    }
		});
	}
	
	// ------------------------------------------------------------------------------
	class LogInListener implements IUiListener {

		@Override
		public void onCancel() {
			
		}

		@Override
		public void onComplete(Object response) {
			mAuthData = (JSONObject)response;
//			{
//				  "ret": 0,
//				  "pay_token": "6558114F4D5518C0383919557DC767DE",
//				  "pf": "desktop_m_qq-10000144-android-2002-",
//				  "query_authority_cost": 318,
//				  "authority_cost": -101428898,
//				  "openid": "4736E8D1D0A42BF6DF94F7A972CDD933",
//				  "expires_in": 7776000,
//				  "pfkey": "a5d82858b2ed386c3fe6f9a328cd16b2",
//				  "msg": "",
//				  "access_token": "F24DE9192D4FB7E96594D33AEAD3E848",
//				  "login_cost": 497
//				}
			mActivity.runOnUiThread(new Runnable() {
				@Override
				public void run() {
					UserInfo info = new UserInfo(mActivity, mTencent.getQQToken());
					info.getUserInfo(new GetUserInfoListener());
				}
			});
		}

		@Override
		public void onError(UiError e) {
			BBNDK.onLogInByQQ(null, null, null, e.errorMessage, e.errorCode);
		}		
	}

	// ------------------------------------------------------------------------------
	class GetUserInfoListener implements IUiListener {

		@Override
		public void onCancel() {
			
		}

		@Override
		public void onComplete(final Object response) {
			logInByAuthData(mTencent.getQQToken().getAccessToken(), String.valueOf(mTencent.getQQToken().getExpireTimeInSecond()), response);
		}

		@Override
		public void onError(UiError e) {
			BBNDK.onLogInByQQ(null, null, null, e.errorMessage, e.errorCode);
		}
	}
	
}
