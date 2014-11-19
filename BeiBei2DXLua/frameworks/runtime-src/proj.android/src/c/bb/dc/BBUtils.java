package c.bb.dc;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

public class BBUtils {
	public static boolean saveFile(String savepath, String filename, byte[] data) {
        try {
        	File file = new File(savepath , filename);
			file.createNewFile();
			FileOutputStream out = new FileOutputStream(file);
			out.write(data);
			out.close();
			
			return true;
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
	}
}
