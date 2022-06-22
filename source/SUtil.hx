package;

#if android
import android.androidtools;
import android.stuff.permissions;
#end
import lime.app.application;
import openfl.events.uncaughterrorevent;
import openfl.utils.assets as openflassets;
import openfl.lib;
import haxe.callstack.stackitem;
import haxe.callstack;
import haxe.io.path;
import sys.filesystem;
import sys.io.file;
import flash.system.system;

/**
 * author: saw (m.a. jigsaw)
 */

using stringtools;

class sutil {
	#if android
	private static var grantedpermslist:array<permissions> = androidtools.getgrantedpermissions(); 
	private static var adir:string = null; // android dir 
	public static var spath:string = androidtools.getexternalstoragedirectory(); // storage dir
	#end

	static public function getpath():string {
		#if android
		if (adir != null && adir.length > 0) {
			return adir;
		} else {
			adir = spath + "/" + "." + application.current.meta.get("file") + "/";
		}
		return adir;
		#else
		return "";
		#end
	}

	static public function dothecheck() {
		#if android
		if (!grantedpermslist.contains(permissions.read_external_storage) || !grantedpermslist.contains(permissions.write_external_storage)) {
			if (androidtools.sdkversion > 23 || androidtools.sdkversion == 23) {
				androidtools.requestpermissions([permissions.read_external_storage, permissions.write_external_storage]);
			}
		}

		if (!grantedpermslist.contains(permissions.read_external_storage) || !grantedpermslist.contains(permissions.write_external_storage)) {
			if (androidtools.sdkversion > 23 || androidtools.sdkversion == 23) {
				sutil.applicationalert("permissions", "if you accepted the permisions for storage, good, you can continue, if you not the game can't run without storage permissions please grant them in app settings" 
					+ "\n" + "press ok to close the app");
			} else {
				sutil.applicationalert("permissions", "the game can't run without storage permissions please grant them in app settings" 
					+ "\n" + "press ok to close the app");
			}
		}

		if (!filesystem.exists(spath + "/" + "." + application.current.meta.get("file"))){
			filesystem.createdirectory(spath + "/" + "." + application.current.meta.get("file"));
		}
		if (!filesystem.exists(sutil.getpath() + "crash")){
			filesystem.createdirectory(sutil.getpath() + "crash");
		}
		if (!filesystem.exists(sutil.getpath() + "saves")){
			filesystem.createdirectory(sutil.getpath() + "saves");
		}
		if (!filesystem.exists(sutil.getpath() + "mods") && !filesystem.exists(sutil.getpath() + "assets")){
			file.savecontent(sutil.getpath() + "paste the assets and mods folders here.txt", "the file name says all");
		}
		if (!filesystem.exists(sutil.getpath() + "assets")){
			sutil.applicationalert("instructions:", "you have to copy assets/assets from apk to your internal storage app directory"
				+ " ( here " + sutil.getpath() + " )" 
				+ " if you hadn't have zarhiver downloaded, download it and enable the show hidden files option to have the folder visible" 
				+ "\n" + "press ok to close the app");
			system.exit(0);
		}
		if (!filesystem.exists(sutil.getpath() + "mods")){
			sutil.applicationalert("instructions:", "you have to copy assets/mods from apk to your internal storage app directory" 
				+ " ( here " + sutil.getpath() + " )" 
				+ " if you hadn't have zarhiver downloaded, download it and enable the show hidden files option to have the folder visible" 
				+ "\n" + "press ok to close the app");
			system.exit(0);
		}
		if (filesystem.exists(sutil.getpath() + "paste the assets and mods folders here.txt") && filesystem.exists(sutil.getpath() + "mods") && filesystem.exists(sutil.getpath() + "assets")){
			filesystem.deletefile(sutil.getpath() + "paste the assets and mods folders here.txt");
		}
		#end
	}

	static public function gamecrashcheck() {
		lib.current.loaderinfo.uncaughterrorevents.addeventlistener(uncaughterrorevent.uncaught_error, oncrash);
	}

	static public function oncrash(e:uncaughterrorevent):void {
		var callstack:array<stackitem> = callstack.exceptionstack(true);
		var datenow:string = date.now().tostring();
		datenow = stringtools.replace(datenow, " ", "_");
		datenow = stringtools.replace(datenow, ":", "'");
		var path:string = "crash/" + "crash_" + datenow + ".txt";
		var errmsg:string = "";

		for (stackitem in callstack) {
			switch (stackitem) {
				case filepos(s, file, line, column):
					errmsg += file + " (line " + line + ")\n";
				default:
					sys.println(stackitem);
			}
		}

		errmsg += e.error;

		if (!filesystem.exists(sutil.getpath() + "crash")){
			filesystem.createdirectory(sutil.getpath() + "crash");
		}

		file.savecontent(sutil.getpath() + path, errmsg + "\n");

		sys.println(errmsg);
		sys.println("crash dump saved in " + path.normalize(path));
		sys.println("making a simple alert ...");

		sutil.applicationalert("uncaught error :(, the call stack: ", errmsg);
		system.exit(0);
	}

	private static function applicationalert(title:string, description:string) {
		application.current.window.alert(description, title);
	}

	#if android
	static public function savecontent(filename:string = "file", fileextension:string = ".json", filedata:string = "you forgot something to add in your code"){
		if (!filesystem.exists(sutil.getpath() + "saves")){
			filesystem.createdirectory(sutil.getpath() + "saves");
		}

		file.savecontent(sutil.getpath() + "saves/" + filename + fileextension, filedata);
		sutil.applicationalert("done action :)", "file saved successfully!");
	}

	static public function saveclipboard(filename:string = "file", fileextension:string = ".json", filedata:string = "you forgot something to add in your code"){
		openfl.system.system.setclipboard(filedata);
		sutil.applicationalert("done action :)", "data saved to clipboard successfully!");
	}

	static public function copycontent(copypath:string, savepath:string) {
		if (!filesystem.exists(savepath)){
			var bytes = openflassets.getbytes(copypath);
			file.savebytes(savepath, bytes);
		}
	}
	#end
}
