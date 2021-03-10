package comicbox.definition;

import boxup.Node;
import boxup.Outcome;
import boxup.Validator;

class ComicboxValidator implements Validator {
  var manager:DefintionManager;
  
  public function new(manager) {
    this.manager = manager;
  }

  public function validate(nodes:Array<Node>):Outcome<Array<Node>> {
    return switch manager.getDefinitionFromNodes(nodes) {
      case Some(def): def.validate(nodes);
      case None: Ok(nodes);
    }
  }
}
