/****************************************************************************
Copyright (c) 2008-2010 Ricardo Quesada
Copyright (c) 2010-2012 cocos2d-x.org
Copyright (c) 2011      Zynga Inc.
Copyright (c) 2013-2014 Chukong Technologies Inc.
 
http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
****************************************************************************/
package com.beibei.wordmaster;

import java.util.ArrayList;
import java.util.Properties;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxGLSurfaceView;  

import android.util.Log;

// import android.app.AlertDialog;
import android.content.Context;
// import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
// import android.provider.Settings;
// import android.view.WindowManager;
import c.bb.dc.AppVersionInfo;
import c.bb.dc.BBNDK;

import com.anysdk.framework.PluginWrapper;
import com.avos.avoscloud.AVAnalytics;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVInstallation;
import com.avos.avoscloud.PushService;
import com.avos.avoscloud.SaveCallback;
import com.umeng.analytics.MobclickAgent;
import com.tencent.stat.MtaSDkException;
import com.tencent.stat.StatConfig;
import com.tencent.stat.StatService;

// The name of .so is specified in AndroidMenifest.xml. NativityActivity will load it automatically for you.
// You can use "System.loadLibrary()" to load other .so files.

public class AppActivity extends Cocos2dxActivity {
	
    public Cocos2dxGLSurfaceView onCreateView() {  
        Cocos2dxGLSurfaceView glSurfaceView = new Cocos2dxGLSurfaceView(this);  
        // TestCpp should create stencil buffer  
        glSurfaceView.setEGLConfigChooser(5, 6, 5, 0, 16, 8);  

        return glSurfaceView;  
    }  
    
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		AppVersionInfo.initServer(this);
        BBNDK.setup(getApplicationContext(), this, AppVersionInfo.WEIXIN_APP_ID);
		
        // 设置默认打开的 Activity
	    PushService.setDefaultPushCallback(this, AppActivity.class);
	    // 订阅频道，当该频道消息到来的时候，打开对应的 Activity
	    PushService.subscribe(this, "public", AppActivity.class);
        Log.d("AVInstallation", AVInstallation.getCurrentInstallation().getInstallationId());
	    // 保存 installation 到服务器
	    AVInstallation.getCurrentInstallation().saveInBackground(new SaveCallback() {
	        @Override
	        public void done(AVException e) {
	        	AVInstallation.getCurrentInstallation().saveInBackground();
	        }
	    });
        
		AVAnalytics.trackAppOpened(getIntent());
		AVAnalytics.enableCrashReport(this, true);
        String pkgName = getApplicationContext().getPackageName();
        AVAnalytics.setAppChannel(pkgName);
		
		PluginWrapper.init(this);
		
		if (BBNDK.nativeIsLandScape()) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
		} else {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_PORTRAIT);
		}
		
		//2.Set the format of window
		
		// Check the wifi is opened when the native is debug.
//		if (BBNDK.nativeIsDebug()) {
//			getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON, WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
//			if (!isNetworkConnected()) {
//				AlertDialog.Builder builder=new AlertDialog.Builder(this);
//				builder.setTitle("Warning");
//				builder.setMessage("Open Wifi for debuging...");
//				builder.setPositiveButton("OK",new DialogInterface.OnClickListener() {
//					
//					@Override
//					public void onClick(DialogInterface dialog, int which) {
//						startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
//						finish();
//						System.exit(0);
//					}
//				});
//				builder.setCancelable(false);
//				builder.show();
//			}
//		}
		BBNDK.setHostIPAdress( getHostIpAddress() );
		
		
		
//		tencent 统计
		StatConfig.setEnableStatService(true);
		String appkey = "Aqc1103783596";
		// 初始化并启动MTA
		// 第三方SDK必须按以下代码初始化MTA，其中appkey为规定的格式或MTA分配的代码。
		// 其它普通的app可自行选择是否调用
		try {
			// 第三个参数必须为：com.tencent.stat.common.StatConstants.VERSION
			StatService.startStatService(this, appkey,
					com.tencent.stat.common.StatConstants.VERSION);
		} catch (MtaSDkException e) {
			// MTA初始化失败
		}
		
		StatService.trackCustomEvent(this, "onLaunch");
//		StatConfig.setMaxStoreEventCount(10000);
//		Properties prop = new Properties();
//		prop.setProperty("device",StatConfig.getMid(this) );
//		StatService.trackCustomKVEvent(this,"1", prop);
//		tencent 统计

	}
	

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data){
		super.onActivityResult(requestCode, resultCode, data);
		PluginWrapper.onActivityResult(requestCode, resultCode, data);
	}
	
	@Override
	protected void onPause() {
//		BBNDK.pushNotification();
		
		PluginWrapper.onPause();
        super.onPause();
        AVAnalytics.onPause(this);
        MobclickAgent.onPause(this);
    }

	@Override
    protected void onResume() {
//		BBNDK.cancelNotification();
		
        super.onResume();
        AVAnalytics.onResume(this);
        MobclickAgent.onResume(this);
        PluginWrapper.onResume();
    }
    
    @Override
    protected void onNewIntent(Intent intent) {
        PluginWrapper.onNewIntent(intent);
        super.onNewIntent(intent);
    }
    
	private boolean isNetworkConnected() {
		ConnectivityManager cm = (ConnectivityManager) getSystemService(Context.CONNECTIVITY_SERVICE);
		if (cm != null) {
			NetworkInfo networkInfo = cm.getActiveNetworkInfo();
			ArrayList<Integer> networkTypes = new ArrayList<Integer>();
			networkTypes.add(ConnectivityManager.TYPE_WIFI);
			try {
				networkTypes.add(ConnectivityManager.class.getDeclaredField("TYPE_ETHERNET").getInt(null));
			} catch (NoSuchFieldException nsfe) {
			} catch (IllegalAccessException iae) {
				throw new RuntimeException(iae);
			}
			if (networkInfo != null && networkTypes.contains(networkInfo.getType())) {
				return true;
			}
		}
		return false;
	}
	 
	public String getHostIpAddress() {
		WifiManager wifiMgr = (WifiManager) getSystemService(WIFI_SERVICE);
		WifiInfo wifiInfo = wifiMgr.getConnectionInfo();
		int ip = wifiInfo.getIpAddress();
		return ((ip & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF) + "." + ((ip >>>= 8) & 0xFF));
	}
}
