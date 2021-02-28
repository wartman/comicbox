package comicbox.provider;

import boxup.Builtin;
import haxe.ds.Option;
import haxe.Exception;
import boxup.Node;
import boxup.Reporter;
import boxup.cli.Definition;
import boxup.cli.DefinitionCompiler;
import boxup.cli.ResourceLoader;

class DefinitionProvider {
  final reporter:Reporter;
  final definitions:Map<String, Definition> = [];

  public function new(reporter) {
    this.reporter = reporter;
    init();
  }

  function init() {
    var defLoader = new DefinitionCompiler(new ResourceLoader(), reporter);
    switch defLoader.load('comic') {
      case Some(definition): 
        definitions.set('comic', definition);
      case None:
        throw new Exception('Could not load comic definition');
    }
    switch defLoader.load('note') {
      case Some(definition): 
        definitions.set('note', definition);
      case None:
        throw new Exception('Could not load note definition');
    }
  }

  public function getDefinition(name:String) {
    return definitions.get(name);
  }

  public function getDefinitionFromNodes(nodes:Array<Node>):Option<Definition> {
    if (nodes.length == 0) return None;
    return switch nodes[0].type {
      case Block(BRoot): getDefinitionFromNodes(nodes[0].children);
      case Block('Comic'): Some(getDefinition('comic'));
      case Block('Note'): Some(getDefinition('note'));
      default: None;
    }
  }
}
