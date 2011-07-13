package
{
	import flash.system.Security;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class YoutubeChromelessPlayer extends MovieClip
	{
		public static const STATE_UNSTARTED:int 							= -1;
		public static const STATE_ENDED:int 								=  0;
		public static const STATE_PLAYING:int 								=  1;
		public static const STATE_PAUSED:int 								=  2;
		
		private static const EVENT_READY:String								= "onReady";
		public static const EVENT_PLAYER_READY:String						= "onPlayerReady";
		public static const EVENT_ERROR:String								= "onError";
		public static const EVENT_STATE_CHANGE:String						= "onStateChange";
		public static const EVENT_PLAYBACK_QUALITY_CHANGE:String			= "onPlaybackQualityChange";
		
		public static const QUALITY_HIGHRES:String							= "highres";
		public static const QUALITY_HD720:String							= "hd720";
		
		private var _player:Object;
		private var loader:Loader;
		private var vWidth:int;
		private var vHeight:int;
		private var videoId:String;
		
		public function init(videoId:String, width:int, height:int):void
		{
			this.vWidth = width;
			this.vHeight = height;
			this.videoId = videoId;
			
			loader = new Loader();
			
			Security.allowInsecureDomain("*");
			Security.allowDomain("*");
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
			
			trace("videoId = " + videoId);
		}
		
		public function get player():Object
		{
			return _player;
		}
		
		public function kill():void
		{
			_player.stopVideo();
			removeListeners();
		}
		
		private function onLoaderInit(e:Event):void
		{
			addChild(loader);
			addListeners();
		}
		
		private function addListeners():void
		{
			loader.content.addEventListener(EVENT_READY, onReady);
			loader.content.addEventListener(EVENT_ERROR, onError);
		}
		
		private function removeListeners():void
		{
			loader.content.removeEventListener(EVENT_READY, onReady);
			loader.content.removeEventListener(EVENT_ERROR, onError);
		}
		
		private function onReady(e:Event):void
		{
			removeListeners();
			
			trace(this + " :: " + e.type + " :: " + Object(e).data);
			
			_player = loader.content;
			_player.setPlaybackQuality(QUALITY_HD720);
			_player.loadVideoById(videoId);
			_player.setSize(vWidth, vHeight);
			
			dispatchEvent(new Event(EVENT_PLAYER_READY));
		}
		
		private function onError(e:Event):void
		{
			trace("ERROR");
			trace(e);
		}
		
	}
}