package comicbox.generator;

import boxup.Outcome;
import boxup.Node;
import boxup.Generator;

class PdfGenerator implements Generator<String> {
  public function new() {
    // todo
  }
  
  public function generate(nodes:Array<Node>):Outcome<String> {
    return Ok('');
  }
}