package {
  import flash.display.*
  import com.sikelianos.*
    
  public class TilerExample extends MovieClip {

    public var _bg:TilingBackground

    public function TilerExample() {  
      var url = "clover.jpg"
      _bg = new TilingBackground(url)
      addChild(_bg)
    }
        
  }
}