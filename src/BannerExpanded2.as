package 
{

	import com.doubleclick.studio.events.StudioEvent;
	import com.doubleclick.studio.expanding.ExpandingComponent;
	import com.doubleclick.studio.net.LocalConnect;
	import com.doubleclick.studio.proxy.Enabler;
	import com.doubleclick.studio.video.VideoComponent;
	import com.greensock.TweenNano;
	import com.greensock.easing.Sine;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.media.SoundMixer;
	import flash.utils.setTimeout;

	public class BannerExpanded2 extends MovieClip
	{
		// These determine what videos to play
		private var _videoIds:Array = [ "JM2krwqckyg", "ys-2KuxuaoY", "VH6b3_7QIlg"];
		
		private var _vWidth:int = 970;
		private var _vHeight:int = 500;
		private var lc:LocalConnect = new LocalConnect();
		private var _testWithFPOTimer:Boolean = true;
		private var _firstTimePlayed:Boolean = true;
		private var _currentVideo:Object;
		private var _currentIndex:int = 0;
		private var ytc:YoutubeChromelessPlayer;

		public function BannerExpanded2()
		{			
			video_container_mc.visible = false;
			video_container_mc.alpha = 0;

			// Event listeners to collapse the creative and pause the video
			collapse_button.addEventListener(MouseEvent.CLICK, collapseCreative);
			exit.addEventListener(MouseEvent.CLICK, pauseVideo);

			lc.setTimeout(10);
			// 10 seconds to test locally, live creative can be less;
			lc.setMode(LocalConnect.MODE_CHILD);
			lc.addEventListener(StudioEvent.ON_CONNECT, onConnectHandler);
			lc.addEventListener(StudioEvent.ON_TIMEOUT, onTimeoutHandler);
			lc.addEventListener(StudioEvent.ON_DATA, onDataHandler);
			lc.setChannelName("child2");
			lc.connect();

			// Add listener for select ending buttons in overlay
			resolve_frame_mc.addEventListener(BannerEvent.ENDING_BTN_CLICKED, endingBtnClicked);
			lc.sendData("lc child2");
			
			//playVideoIndex(1);
		}

		private function addListeners():void
		{
			ytc.addEventListener(YoutubeChromelessPlayer.EVENT_PLAYER_READY, playerReady);
			ytc.init(_videoIds[_currentIndex], _vWidth, _vHeight);
		}
		
		private function playerReady(e:Event):void
		{
			_currentVideo = ytc.player;
			ytc.removeEventListener(YoutubeChromelessPlayer.EVENT_PLAYER_READY, playerReady);
			_currentVideo.addEventListener(YoutubeChromelessPlayer.EVENT_STATE_CHANGE, onStateChange);
		}
		
		private function onStateChange(e:Event):void
		{
			switch(Object(e).data)
			{
				case YoutubeChromelessPlayer.STATE_ENDED:
					onVideoComplete();
					break;
				case YoutubeChromelessPlayer.STATE_PLAYING:
					onVideoPlay();
					break;
				default:
					break;
			}
		}
		

		private function removeListeners():void
		{
			ytc.kill();
			_currentVideo.removeEventListener(YoutubeChromelessPlayer.EVENT_STATE_CHANGE, onStateChange);
		}

		private function onVideoPlay():void
		{
			if (_firstTimePlayed)
			{
				_firstTimePlayed = false;
				play();
			}
			TweenNano.to(video_container_mc, 0.3, { alpha:1, ease:Sine.easeOut });
			video_container_mc.visible = true;
			exit.visible = true;
		}

		private function endingBtnClicked(e:BannerEvent):void
		{
			trace("BanerExpanded :: endingBtnClicked " + e.index);
			playVideoIndex(e.index);
			
			exit.visible = true;
		}
		
		public function unloadSWFexp():void
		{
			//removeListeners()
		}
		
		private function collapseCreative(event:MouseEvent):void
		{
			Enabler.stopAllVideos();
			SoundMixer.stopAll();
			stop();

			ExpandingComponent.collapse();
		}

		private function pauseVideo(e:MouseEvent):void
		{
		}

		private function onVideoComplete(e:StudioEvent = null):void
		{
			removeListeners();
			TweenNano.to(video_container_mc, 0.5, { alpha:0, ease:Sine.easeOut, onComplete:function():void {
				video_container_mc.visible = false;
				exit.visible = false;
				video_container_mc.gotoAndStop(4);
			}});
			removeListeners();
		}

		// Local Connection Stuff
		private function onConnectHandler(event:StudioEvent):void
		{
			trace("CHILD EXPANDED :: connection made with parent");
		}

		private function onTimeoutHandler(event:StudioEvent):void
		{
			trace("CHILD EXPANDED :: connection timed out");
		}

		private function onDataHandler(e:StudioEvent):void
		{
			trace("CHILD EXPANDED :: data received = " + e.data);
			playVideoIndex(e.data);
		}

		private function playVideoIndex(index):void
		{
			_currentIndex = index;
			var sIndex:int = _currentIndex+1;
			video_container_mc.gotoAndStop(sIndex);
			ytc = video_container_mc["ytVideo" + sIndex];
			addListeners();
		}
	}
}