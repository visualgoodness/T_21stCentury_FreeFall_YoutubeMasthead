﻿package 
{
	import com.doubleclick.studio.net.LocalConnect;
	import com.doubleclick.studio.events.StudioEvent;
	import com.doubleclick.studio.Enabler;
	import com.doubleclick.studio.expanding.ExpandingComponent;
	
	import flash.display.MovieClip;
	import flash.system.Security;

	public class BannerParent extends MovieClip
	{
		private var lc:LocalConnect = createLocalConnection("child1");
		private var lc2:LocalConnect;
		private var activeConnection:LocalConnect = lc;
		private var endingSelected:int = -1;
		
		public function BannerParent()
		{
			Security.allowInsecureDomain("*");
			Security.allowDomain("*");
		}
		
		private function onConnectHandler(event:StudioEvent):void {
			trace("---- PARENT :: connection made with child");
			if (activeConnection == lc2)
			{
				lc2.sendData(endingSelected);
			}
		}
		
		private function onTimeoutHandler(event:StudioEvent):void {
			trace("---- PARENT :: connection timed out");
		}
		
		private function onDataHandler(event:StudioEvent):void {
			
			trace("---- PARENT :: received data + " + event.data + " from sender");

				endingSelected = event.data;
				lc2 = createLocalConnection("child2");
				activeConnection = lc2;
			

		}

		private function createLocalConnection(channelName:String):LocalConnect
		{
			var lc:LocalConnect = new LocalConnect();
			lc.setTimeout(10); // 10 seconds to test locally, live creative can be less
			lc.setMode(LocalConnect.MODE_PARENT);
			lc.addEventListener(StudioEvent.ON_CONNECT, onConnectHandler);
			lc.addEventListener(StudioEvent.ON_TIMEOUT, onTimeoutHandler);
			lc.addEventListener(StudioEvent.ON_DATA, onDataHandler);
			lc.addChildChannel(channelName);
			lc.connect();
			return lc;
		}
	}
}
