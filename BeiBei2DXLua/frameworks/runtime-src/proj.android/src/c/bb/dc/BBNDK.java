package c.bb.dc;

import org.cocos2dx.lib.Cocos2dxActivity;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Environment;
import android.widget.Toast;

import com.avos.avoscloud.AVAnalytics;
import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVFile;
import com.avos.avoscloud.AVUser;
import com.avos.avoscloud.GetDataCallback;
import com.avos.avoscloud.GetFileCallback;
import com.avos.avoscloud.LogInCallback;
import com.avos.avoscloud.ProgressCallback;
import com.avos.avoscloud.SignUpCallback;

public class BBNDK {
	private static String _hostIPAdress = "0.0.0.0";
	private static Context _context = null;
	private static Activity _instance = null;
	
	public static Context getContext() {
		return _context;
	}

	public static void setup(Context context, Activity instance) {
		_context = context;
		_instance = instance;
	}
	
	// ***************************************************************************************************************************
	// cocos2d-x runtime
	// ***************************************************************************************************************************
	
	public static void setHostIPAdress(String hostIPAdress) {
		_hostIPAdress = hostIPAdress;
	}
	
	public static String getLocalIpAddress() {
		return _hostIPAdress;
	}
	
	public static String getSDCardPath() {
		if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) {
			String strSDCardPathString = Environment.getExternalStorageDirectory().getPath();
           return  strSDCardPathString;
		}
		return null;
	} 
	
	// ***************************************************************************************************************************
	// feedback
	// ***************************************************************************************************************************
	
	public static void showMail(String mailTitle, String username) {
		Intent intent = new Intent(Intent.ACTION_SENDTO);
		intent.setData(Uri.parse("mailto:beibeidanci@qq.com"));
//		intent.setType("message/rfc822");
//		intent.putExtra(Intent.EXTRA_EMAIL  , new String[]{"beibeidanci@qq.com"});
		intent.putExtra(Intent.EXTRA_SUBJECT, mailTitle + ":" + username);
		intent.putExtra(Intent.EXTRA_TEXT   , "这是我的反馈，贝贝请认真看哦!\n");
		try {
			_instance.startActivity(Intent.createChooser(intent, "发送反馈邮件"));
		} catch (android.content.ActivityNotFoundException ex) {
		    Toast.makeText(_instance, "There are no email clients installed.", Toast.LENGTH_SHORT).show();
		}
	}
	
	// ***************************************************************************************************************************
	// LeanCloud AVAnalytics
	// ***************************************************************************************************************************
	
	public static void onEvent(String eventName, String  tag) {  
		if (_context != null) {
			AVAnalytics.onEvent(_context, eventName, tag);
		}
	}
	
	// ***************************************************************************************************************************
	// LeanCloud download
	// ***************************************************************************************************************************
	
	public static void downloadFile(final String objectId, final String savepath) {
		AVFile.withObjectIdInBackground(objectId, new GetFileCallback<AVFile>() {
			@Override
			public void done(final AVFile file, AVException e) {
				if (file == null || e != null) {
					onDownloadFile(objectId, file != null ? file.getOriginalName() : "", e != null ? e.getLocalizedMessage() : "get file object error", 0);
				} else {
					file.getDataInBackground(new GetDataCallback() {
						@Override
						public void done(byte[] data, AVException arg1) {
							if (arg1 != null) {
								onDownloadFile(objectId, file != null ? file.getOriginalName() : "", arg1.getLocalizedMessage(), 0);
							} else {
								if (data != null && data.length > 0 && BBUtils.saveFile(savepath, file.getOriginalName(), data)) {
									onDownloadFile(objectId, file.getOriginalName(), "save file succeed", 1);
								} else {
									onDownloadFile(objectId, file.getOriginalName(), "save file error", 0);
								}
							}
						}
					}, new ProgressCallback() {
						@Override
						public void done(Integer arg0) {
						}						
					});
				}
			}
		});
	}
	
	private static void onDownloadFile(final String objectId, final String filename, final String error, final int isSaved) {
		((Cocos2dxActivity)(_instance)).runOnGLThread(new Runnable() {

			@Override
			public void run() {
				invokeLuaCallbackFunctionDL(objectId, filename, error, isSaved);
			}
			
		});
	}
	
	public static void downloadWordSoundFiles(final String prefix, final String wordsList, final String subfix, final String path) {
		String[] words = wordsList.split("\\|");
		BBWordSoundFileDownloader first = new BBWordSoundFileDownloader(words, 0, words.length, prefix, subfix, path);
		first.start();
	}
	
	public static void downloadConfigFiles(final String objectIds, final String path) {
		String[] ids = objectIds.split("\\|");
		BBConfigsDownloader o = new BBConfigsDownloader(ids, 0, ids.length, path);
		o.start();
	}
	
	// ***************************************************************************************************************************
	// LeanCloud sign up, log in, log out
	// ***************************************************************************************************************************
	
	private static String AVUserToJsonStr(AVUser user) {
//		TODO: Android unknown error
//		org.json.JSONObject json = user.toJSONObject();
//		return json.toString();
		
		return user.getSessionToken();
	}
	
	public static void signUp(String username, String password) {
		final AVUser user = new AVUser();
		user.setUsername(username);
		user.setPassword(password);
		user.signUpInBackground(new SignUpCallback() {
		    public void done(AVException e) {
		        if (e == null) {
		        	invokeLuaCallbackFunctionSU(AVUserToJsonStr(user), null, 0);
		        } else {
		        	invokeLuaCallbackFunctionSU(null, e.getLocalizedMessage(), e.getCode());
		        }
		    }
		});
	}
	
	public static void logIn(String username, String password) {
		AVUser.logInInBackground(username, password, new LogInCallback<AVUser>() {
			public void done(AVUser user, AVException e) {
		        if (e == null) {
		        	invokeLuaCallbackFunctionLI(AVUserToJsonStr(user), null, 0);
		        } else {
		        	invokeLuaCallbackFunctionLI(null, e.getLocalizedMessage(), e.getCode());
		        }
		    }
		});
	}
	
	public static void logOut() {
		AVUser.logOut();
	}
	
	// ***************************************************************************************************************************
	// loading circle
	// ***************************************************************************************************************************
	
	private static ProgressDialog _loadingView = null;
	
	public static void showCXProgressHUD(final String content) {
		_instance.runOnUiThread(new Runnable() {

			@Override
			public void run() {
				_hideCXProgressHUD();
				if (_loadingView == null) {
					_loadingView = ProgressDialog.show(_instance, "", content, true);
				}
			}
			
		});
	}
	
	private static void _hideCXProgressHUD() {
		if (_loadingView != null) {
			_loadingView.dismiss();
		}
		_loadingView = null;
	}
	
	public static void hideCXProgressHUD() {
		_instance.runOnUiThread(new Runnable() {

			@Override
			public void run() {
				_hideCXProgressHUD();
			}
			
		});
	}
	
	// ***************************************************************************************************************************
	// native
	// ***************************************************************************************************************************
	
	public static native boolean nativeIsLandScape();
	public static native boolean nativeIsDebug();
	public static native void invokeLuaCallbackFunctionDL(String objectId, String filename, String error, int isSaved);
	public static native void invokeLuaCallbackFunctionSU(String objectjson, String error, int errorcode);
	public static native void invokeLuaCallbackFunctionLI(String objectjson, String error, int errorcode);
}
