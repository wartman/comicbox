package comicbox.boxup;

import haxe.ds.Option;
import boxup.Builtin;
import boxup.Source;
import boxup.Node;
import boxup.cli.DefinitionId;
import boxup.cli.DefinitionIdResolver;

class NodeResolver implements DefinitionIdResolver {
  public final priority:Int = 0;

  public function new() {}

  public function resolveDefinitionId(nodes:Array<Node>, source:Source):Option<DefinitionId> {
    if (nodes.length == 0) return None;
    return switch nodes[0].type {
      case Block(BRoot): resolveDefinitionId(nodes[0].children, source);
      case Block('Comic'): Some('comic');
      case Block('Note'): Some('note');
      default: None;
    }
  }
}
