package c.bb.dc.sns;

import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import c.bb.dc.BBNDK;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVUser;
import com.avos.avoscloud.LogInCallback;
import com.tencent.connect.UserInfo;
import com.tencent.connect.share.QQShare;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;

//TODO : just log in
public class CXTencentSDKCall {
	public static String SNSTYPE = "qq";
	
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
	
	// ------------------------------------------------------------------------------
	
	public void logIn() {
		if (!mTencent.isSessionValid()) {
			mTencent.login(mActivity, "all", new LogInListener());
		}
	}
	
	public void logInByAuthData(String openid, String access_token, String expires_in, final Object response) {
		AVUser.AVThirdPartyUserAuth userAuth = new AVUser.AVThirdPartyUserAuth(access_token, expires_in, "qq", openid);
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
	
	public void shareImageToQQFriend(String path, String title, String desc) {
	    Bundle params = new Bundle();
	    params.putString(QQShare.SHARE_TO_QQ_IMAGE_LOCAL_URL, path);
	    params.putString(QQShare.SHARE_TO_QQ_TITLE, title);
	    params.putString(QQShare.SHARE_TO_QQ_SUMMARY, desc);
	    params.putInt(QQShare.SHARE_TO_QQ_KEY_TYPE, QQShare.SHARE_TO_QQ_TYPE_IMAGE);
	    params.putInt(QQShare.SHARE_TO_QQ_EXT_INT, QQShare.SHARE_TO_QQ_FLAG_QZONE_AUTO_OPEN);
	    mTencent.shareToQQ(mActivity, params, new ShareImageToQQFriendListener());
	}

	// ------------------------------------------------------------------------------
	class LogInListener implements IUiListener {

		@Override
		public void onCancel() {
			BBNDK.onLogInByQQ(null, null, null, "User cancels QQ log in", 0);
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
			BBNDK.onLogInByQQ(null, null, null, "User cancels QQ log in", 0);
		}

		@Override
		public void onComplete(final Object response) {
			AVUser.AVThirdPartyUserAuth userAuth = new AVUser.AVThirdPartyUserAuth(
					mTencent.getQQToken().getAccessToken(), 
					String.valueOf(mTencent.getQQToken().getExpireTimeInSecond()), 
					SNSTYPE, 
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
	
	// ------------------------------------------------------------------------------
	class ShareImageToQQFriendListener implements IUiListener {

		@Override
		public void onCancel() {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onComplete(Object arg0) {
			// TODO Auto-generated method stub
			
		}

		@Override
		public void onError(final UiError error) {
			mActivity.runOnUiThread(new Runnable() {

				@Override
				public void run() {
					new AlertDialog.Builder(mActivity)							
							.setMessage(error.errorMessage)
							.setNegativeButton("CLOSE", null)
							.create()
							.show();
				}

			});
		}
			
	}
}
