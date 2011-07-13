package
{
	import com.doubleclick.studio.events.StudioEvent;
	import com.doubleclick.studio.expanding.ExpandingComponent;
	import com.doubleclick.studio.net.LocalConnect;
	import com.doubleclick.studio.proxy.Enabler;
	import com.greensock.TweenNano;
	import com.greensock.easing.Sine;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	public class BannerCollapsed extends MovieClip
	{
		private var lc:LocalConnect = new LocalConnect();
		private var selectedEnding:int = -1;
			
		public function BannerCollapsed()
		{
			// Listen for collapse to bring overlay back up
			ExpandingComponent.addEventListener(StudioEvent.ON_COLLAPSE, onCollapse);
			ExpandingComponent.addEventListener(StudioEvent.ON_EXPAND, onExpand);
			
			lc.setTimeout(10); // 10 seconds to test locally, live creative can be less
			lc.setMode(LocalConnect.MODE_CHILD);
			lc.addEventListener(StudioEvent.ON_CONNECT, onConnectHandler);
			lc.addEventListener(StudioEvent.ON_TIMEOUT, onTimeoutHandler);
			lc.addEventListener(StudioEvent.ON_DATA, onDataHandler);
			lc.setChannelName("child1");
			lc.connect();
			
			// Add listener for select ending buttons in overlay
			initial_frame_overlay_mc.addEventListener(BannerEvent.ENDING_BTN_CLICKED, endingBtnClicked);
			dcVideo.addEventListener(StudioEvent.ON_VIDEO_COMPLETE, videoComplete);
			dcVideo.addEventListener(StudioEvent.ON_VIDEO_PLAY, videoPlay);
			
		}
		
		private function videoComplete(e:StudioEvent):void
		{
			dcVideo.visible=false;
		}
		
		private function videoPlay(e:StudioEvent):void
		{
			TweenNano.to(vid_curtain_mc, 0.3, { alpha:0, ease:Sine.easeOut });
		}
		
		private function onCollapse(e:StudioEvent):void
		{
			gotoAndPlay("doCollapse");
		}
		
		private function onExpand(e:StudioEvent):void
		{
			lc.sendData(selectedEnding);
		}
		
		// Once overlay transitout out is complete, do the actual exapansion
		private function doExpand():void
		{
			trace("doExpand");
			ExpandingComponent.expand();
			
			
		}
		
		private function endingBtnClicked(e:BannerEvent):void
		{
			trace("endingBtnClicked " + e.index);
			dcVideo.pause();
			gotoAndPlay("doExpand");
			selectedEnding = e.index+1;
			dcVideo.visible=false;
			
		}
		
		// Local connection for syching between banners
		private function onConnectHandler(event:StudioEvent):void
		{
			trace("CHILD COLLAPSED :: connection made with parent");
		}
		
		private function onTimeoutHandler(event:StudioEvent):void
		{
			trace("CHILD COLLAPSED :: connection timed out");
		}
		
		private function onDataHandler(event:StudioEvent):void
		{
			trace("CHILD COLLAPSED :: has recieved " + event.data + " from " + event.sender);
		}
	}
}