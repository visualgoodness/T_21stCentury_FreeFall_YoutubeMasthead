package 
{

	import com.doubleclick.studio.proxy.Enabler;
	import com.doubleclick.studio.events.StudioEvent;
	import com.doubleclick.studio.expanding.ExpandingComponent;

	import com.doubleclick.studio.net.LocalConnect;

	import com.greensock.TweenNano;
	import com.greensock.easing.Sine;

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.media.SoundMixer;
	import flash.utils.setTimeout;
	import com.doubleclick.studio.video.VideoComponent;

	public class BannerExpanded extends MovieClip
	{
		private var lc:LocalConnect = new LocalConnect();
		private var _testWithFPOTimer:Boolean = true;
		private var _firstTimePlayed:Boolean = true;
		private var _currentVideo:VideoComponent;

		public function BannerExpanded()
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
		}

		private function addListeners():void
		{

			_currentVideo.addEventListener(StudioEvent.ON_VIDEO_COMPLETE, onVideoComplete);
			_currentVideo.addEventListener(StudioEvent.ON_VIDEO_PLAY, onVideoPlay);
		}

		private function removeListeners():void
		{

			_currentVideo.removeEventListener(StudioEvent.ON_VIDEO_COMPLETE, onVideoComplete);
			_currentVideo.removeEventListener(StudioEvent.ON_VIDEO_PLAY, onVideoPlay);
		}

		private function onVideoPlay(e:StudioEvent):void
		{
			if (_firstTimePlayed)
			{
				TweenNano.to(video_container_mc, 0.3, { alpha:1, ease:Sine.easeOut });
				video_container_mc.visible = true;
				exit.visible = true;
				_firstTimePlayed = false;
				play();
			}
		}

		private function endingBtnClicked(e:BannerEvent):void
		{
			video_container_mc.visible = true;
			video_container_mc.alpha = 1;


			trace("BanerExpanded :: endingBtnClicked " + e.index);
			switch (e.index)
			{
				case 0 :
					video_container_mc.gotoAndStop(1);
					_currentVideo = video_container_mc.dcVideo1;
					_currentVideo.addEventListener(StudioEvent.ON_VIDEO_COMPLETE, onVideoComplete);
					_currentVideo.addEventListener(StudioEvent.ON_VIDEO_PLAY, onVideoPlay);
					break;
				case 1 :
					video_container_mc.gotoAndStop(2);
					_currentVideo = video_container_mc.dcVideo2;
					_currentVideo.addEventListener(StudioEvent.ON_VIDEO_COMPLETE, onVideoComplete);
					_currentVideo.addEventListener(StudioEvent.ON_VIDEO_PLAY, onVideoPlay);
					break;
				case 2 :
					video_container_mc.gotoAndStop(3);
					_currentVideo = video_container_mc.dcVideo3;
					_currentVideo.addEventListener(StudioEvent.ON_VIDEO_COMPLETE, onVideoComplete);
					_currentVideo.addEventListener(StudioEvent.ON_VIDEO_PLAY, onVideoPlay);
					break;


					_currentVideo.seek(0);
					_currentVideo.play();
			}

			//video_container_mc.gotoAndStop(e.index+1);
			//_currentVideo = video_container_mc.dcVideo2;

			//_currentVideo.seek(0);
			//_currentVideo.play();

			//addListeners();
			//resolve_frame_mc.gotoAndStop(1);
			//TweenNano.to(video_container_mc, 0.5, { alpha:1, ease:Sine.easeOut });
			exit.visible = true;




		}
		public function unloadSWFexp():void
		{
			//removeListeners()
			
		}
		// Function to collapse the creative
		private function collapseCreative(event:MouseEvent):void
		{
			Enabler.stopAllVideos();
			SoundMixer.stopAll();
			stop();

			ExpandingComponent.collapse();

		}


		// Function to pause the video when the exit is clicked
		private function pauseVideo(e:MouseEvent):void
		{
			/*
			if (video_container_mc.dcVideo1.isPlaying())
			{
			video_container_mc.dcVideo1.pause();
			}
			if (video_container_mc.dcVideo2.isPlaying())
			{
			video_container_mc.dcVideo2.pause();
			}
			if (video_container_mc.dcVideo3.isPlaying())
			{
			video_container_mc.dcVideo3.pause();
			}
			collapseCreative(e);
			*/
		}

		private function onVideoComplete(e:StudioEvent = null):void
		{

			TweenNano.to(video_container_mc, 0.5, { alpha:0, ease:Sine.easeOut, onComplete:function():void {;
			//video_container_mc.gotoAndStop(4); ;
			video_container_mc.visible = false;
			exit.visible = false;
			video_container_mc.gotoAndStop(4);
			}});
			removeListeners();
			//resolve_frame_mc.play();
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
			video_container_mc.gotoAndStop(index);
			_currentVideo = video_container_mc["dcVideo" + index];
			trace(_currentVideo);
			_currentVideo.mouseEnabled = false;
			addListeners();
			//_currentVideo.play();
		}
	}
}