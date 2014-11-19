package c.bb.dc;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVFile;
import com.avos.avoscloud.GetDataCallback;
import com.avos.avoscloud.GetFileCallback;

public class BBDownloader {
	public void start() {
		
	}
	
	protected void download(String objectId) {
		AVFile.withObjectIdInBackground(objectId, new GetFileCallback<AVFile>() {
			@Override
			public void done(final AVFile file, AVException e) {
				if (file == null || e != null) {
					gotoNext();
				} else {
					file.getDataInBackground(new GetDataCallback() {
						@Override
						public void done(byte[] data, AVException err) {
							if (err == null) {
								BBUtils.saveFile(_path, file.getOriginalName(), data);
							}
							gotoNext();
						}
					});
				}
			}
		});
	}
	
	protected void gotoNext() {

	}
	
	protected String _path;
}
