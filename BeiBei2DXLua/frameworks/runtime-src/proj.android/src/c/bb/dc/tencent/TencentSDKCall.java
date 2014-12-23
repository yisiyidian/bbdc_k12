package c.bb.dc.tencent;

import android.app.Activity;

import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;

public class TencentSDKCall implements IUiListener {
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
	
	//

	@Override
	public void onCancel() {
		
	}

	@Override
	public void onComplete(Object arg0) {
		
	}

	@Override
	public void onError(UiError arg0) {
		
	}
}
