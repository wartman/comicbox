package comicbox.document;

import vscode.EventEmitter;
import vscode.TextDocument;
import boxup.Reporter;
import boxup.Source;
import boxup.Parser;
import boxup.Node;
import comicbox.definition.DefintionManager;

class DocumentManager {
  final definitions:DefintionManager;
  final reporter:Reporter;
  final parsedDocuments:Map<String, Array<Node>> = [];
  public final events:EventEmitter<{ doc:TextDocument, nodes:Array<Node> }> = new EventEmitter();
  
  public function new(reporter, definitions) {
    this.reporter = reporter;
    this.definitions = definitions;
  }

  public function getDocument(uri:String) {
    return parsedDocuments.get(uri);
  }

  public function setDocument(uri:String, nodes:Array<Node>) {
    parsedDocuments.set(uri, nodes);
  }

  public function removeDocument(uri:String) {
    parsedDocuments.remove(uri);
  }

  public function parseDocument(document:TextDocument) {
    var source = new Source(document.uri.toString(), document.getText());
    var result = source.tokens
      .map(tokens -> new Parser(tokens).parse())
      .map(nodes -> switch definitions.getDefinitionFromNodes(nodes) {
        case None: Ok(nodes);
        case Some(def): def.validate(nodes);
      })
      .map(nodes -> {
        parsedDocuments.set(document.uri.toString(), nodes);
        Ok(nodes);
      });
    switch result {
      case Ok(nodes):
        events.fire({
          doc: document,
          nodes: nodes
        });
      case Fail(error): 
        reporter.report(error, source);
    }
  }
}