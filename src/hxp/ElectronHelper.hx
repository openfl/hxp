package hxp;


import hxp.PathHelper;
import hxp.ProcessHelper;
import hxp.Project;


class ElectronHelper {
	
	
	public static function launch (project:Project, path:String):Void {
		
		var electronPath = project.defines.get ("ELECTRON_PATH");
		
		if (electronPath == null || electronPath == "") {
			
			electronPath = "electron";
			
		} else {
			
			electronPath = PathHelper.combine (electronPath, "electron");
			
		}
		
		ProcessHelper.runCommand ("", electronPath, [ path ]);
		
	}
	
	
}