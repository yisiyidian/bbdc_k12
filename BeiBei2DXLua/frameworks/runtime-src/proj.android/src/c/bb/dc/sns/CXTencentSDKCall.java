package c.bb.dc.sns;

import org.json.JSONObject;

import android.app.Activity;
import c.bb.dc.BBNDK;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVUser;
import com.avos.avoscloud.LogInCallback;
import com.tencent.connect.UserInfo;
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
	
	// ------------------------------------------------------------------------------
	class LogInListener implements IUiListener {

		@Override
		public void onCancel() {
			
		}

		@Override
		public void onComplete(Object response) {
			mAuthData = (JSONObject)response;
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
			AVUser.AVThirdPartyUserAuth userAuth = new AVUser.AVThirdPartyUserAuth(
					mTencent.getQQToken().getAccessToken(), 
					String.valueOf(mTencent.getQQToken().getExpireTimeInSecond()), 
					"qq", 
					mTencent.getQQToken().getOpenId());
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

		@Override
		public void onError(UiError e) {
			BBNDK.onLogInByQQ(null, null, null, e.errorMessage, e.errorCode);
		}
	}
	
}
