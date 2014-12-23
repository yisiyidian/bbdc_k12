package c.bb.dc.tencent;

import android.app.Activity;

import com.tencent.tauth.Tencent;

public class TencentSDKCall {
	public static Tencent mTencent;
	public static TencentSDKCall mInstance;
	
	public static TencentSDKCall getInstance() {
		if (mInstance == null) {
			mInstance = new TencentSDKCall();
		}
		return mInstance;
		
	}
	
	public static void init(String appId, Activity act) {
		mTencent = Tencent.createInstance(appId, act);
	}
}
