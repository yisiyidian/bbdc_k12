package c.bb.dc;

import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.os.AsyncTask;

import com.walnutlabs.android.ProgressHUD;

public class BBProgressHUD extends AsyncTask<Void, String, Void> implements OnCancelListener {
//	ProgressHUD mProgressHUD = null;
	boolean mIsShowing = false;
	String mContent = "";
	
	public BBProgressHUD() {
		super();
	}
	
	public void setContent(String content) {
		mContent = content;
	}
	
	public void hide() {
		mIsShowing = false;
	}
	
	@Override
	protected void onPreExecute() {
		mIsShowing = true;
//    	mProgressHUD = ProgressHUD.show(BBNDK.getActivity(), "Loading", true, true, this);
		super.onPreExecute();
	}
	
	@Override
	protected void onPostExecute(Void result) {
//		mProgressHUD.dismiss();
		super.onPostExecute(result);
	}
	
	@Override
	public void onCancel(DialogInterface dialog) {
		this.cancel(true);
//		mProgressHUD.dismiss();
	}

	@Override
	protected Void doInBackground(Void... params) {
		
		while (mIsShowing) {
			
		}
		
		return null;
	}
	
}

