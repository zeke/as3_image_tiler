package {
  import Globals
	import flash.display.*
	import flash.events.*
	import flash.net.*
  import de.popforge.events.*
  import caurina.transitions.Tweener;
  import caurina.transitions.properties.FilterShortcuts;
  import flash.system.LoaderContext;

	public class Image extends MovieClip {

    public var _id:Number
    public var _url:String
    public var _loaded:Boolean = false
    public var _num_images:Number
    public var _loader:Loader
    
		public function Image(id, url) {
		  name = "image_" + id
		  _id = id
      _url = url
      addEventListener(Event.ADDED_TO_STAGE, init)
		}

    function init(e:Event) {
	    _num_images = Globals.vars.slide_list.split(";").length
      load()
    }
    
		function load() { 	  
      var context = new LoaderContext();
      context.checkPolicyFile = false;
		  
      _loader = new Loader();
      _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, show)
      var request:URLRequest = new URLRequest(_url);
      _loader.load(request,context);
	 	}
	 	
		function show(loadEvent:Event) {
			_loaded = true
			addChild(_loader)
      scale()
      position()
      if (isFirst()) {
        appearAndFadeIn();
      } else {
        hide();
      }
		}
		
    function scale() {
			var stage_aspect = stage.stageWidth / stage.stageHeight
			var image_aspect = width / height
			
			if (image_aspect > stage_aspect) {
			  var x_scale = width / stage.stageWidth
			  if (x_scale > 1) scaleX = scaleY = 1/x_scale
			} else {
			  var y_scale = height / stage.stageHeight
			  if (y_scale > 1) scaleX = scaleY = 1/y_scale
			}
    }
    
    function position() {
      
      switch (Globals.vars.align_horizontal) {
      case "left":
        x = 0
        break;
      case "right":
        x = stage.stageWidth - width
      break;
      default: // center
        x = stage.stageWidth/2 - width/2
        break;
      }
      
      switch (Globals.vars.align_vertical) {
      case "top":
        y = 0
        break;
      case "bottom":
        y = stage.stageHeight - height
      break;
      default: // middle
        y = stage.stageHeight/2 - height/2
        break;
      }            
    }
        
    function appearAndFadeIn() {
      MovieClip(MovieClip(parent).getChildByName("spinner")).fadeOut()
      
      visible = true
      alpha = 0
      Tweener.addTween(this, {alpha:1, time:Globals.vars.appear_time, transition:"easeInCubic"})
      Tweener.addTween(this, {rotation:0, time:Globals.vars.appear_time + Globals.vars.display_time, onComplete:tryShowingNext})
    }
    
    function tryShowingNext() {
      var next_image = next()
      if (next_image._loaded) {
        fadeOut()
        next_image.appearAndFadeIn()
      } else {
        // This is a fudged way of checking every five half second for the next image to loaded
        Tweener.addTween(this, {alpha:1, time:1, onComplete:tryShowingNext})
      }
    }

    function fadeOut() {
      Tweener.addTween(this, {alpha:0, time:Globals.vars.fade_out_time, transition:"easeOutCubic", onComplete:hide})
    }
    
    function hide() {
      visible = false
    }
		
		function previous() {
		  var id = (this.isFirst()) ? _num_images-1 : _id-1
		  return MovieClip(parent.getChildByName("image_"+id))
		}

		function next() {
		  var id = (this.isLast()) ? 0 : _id+1
		  return MovieClip(parent.getChildByName("image_"+id))
		}
		
		function isFirst() {
		  return (_id == 0) ? true : false
		}
		
		function isLast() {
		  return (_id == _num_images-1) ? true : false
		}
	}
}