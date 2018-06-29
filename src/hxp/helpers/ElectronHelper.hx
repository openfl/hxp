package hxp.helpers;


import hxp.helpers.PathHelper;
import hxp.helpers.ProcessHelper;
import hxp.project.HXProject;


class ElectronHelper {
	
	
	public static function launch (project:HXProject, path:String):Void {
		
		var electronPath = project.defines.get ("ELECTRON_PATH");
		
		if (electronPath == null || electronPath == "") {
			
			electronPath = "electron";
			
		} else {
			
			electronPath = PathHelper.combine (electronPath, "electron");
			
		}
		
		ProcessHelper.runCommand ("", electronPath, [ path ]);
		
	}
	
	
}