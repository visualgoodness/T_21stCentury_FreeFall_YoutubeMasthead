package
{
	import com.doubleclick.studio.events.StudioEvent;
	import com.doubleclick.studio.expanding.ExpandingComponent;
	import com.doubleclick.studio.net.LocalConnect;
	import com.doubleclick.studio.proxy.Enabler;
	import com.greensock.TweenNano;
	import com.greensock.easing.Sine;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class BannerCollapsed2 extends MovieClip
	{
		private var lc:LocalConnect = new LocalConnect();
		private var selectedEnding:int = -1;
		private var video:*;
		private var ytc:YoutubeChromelessPlayer;
		private var hasPlayedOnce:Boolean = false;
		
		public function BannerCollapsed2()
		{
			ytc = tyVideo;
			ytc.addEventListener(YoutubeChromelessPlayer.EVENT_PLAYER_READY, playerReady);
			ytc.init("cARr5CuzvPE", 970, 250);
			
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
			
		}
		
		private function playerReady(e:Event):void
		{
			video = ytc.player;
			ytc.removeEventListener(YoutubeChromelessPlayer.EVENT_PLAYER_READY, playerReady);
			video.addEventListener(YoutubeChromelessPlayer.EVENT_STATE_CHANGE, onStateChange);
		}
		
		private function onStateChange(e:Event):void
		{
			trace("onStateChange :: " + Object(e).data);
			
			switch(Object(e).data)
			{
				case YoutubeChromelessPlayer.STATE_ENDED:
					videoComplete();
					break;
				case YoutubeChromelessPlayer.STATE_PLAYING:
					if (!hasPlayedOnce)
					{
						hasPlayedOnce = true;
						videoPlay();
					}
					break;
				default:
					break;
			}
		}
		
		private function onPlaybackQualityChange(e:Event):void
		{
			trace(Object(e).data);
		}
		
		private function videoComplete():void
		{
			ytc.visible=false;
		}
		
		private function videoPlay():void
		{
			TweenNano.to(vid_curtain_mc, 0.3, { alpha:0, ease:Sine.easeOut });
		}
		
		private function onCollapse(e:StudioEvent):void
		{
			//gotoAndPlay("doCollapse");
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
			//video.pauseVideo();
			//gotoAndPlay("doExpand");
			selectedEnding = e.index;
			//ytc.visible=false;
			doExpand();
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