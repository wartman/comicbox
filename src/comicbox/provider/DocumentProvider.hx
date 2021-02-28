package comicbox.provider;

import vscode.TextDocument;
import boxup.Reporter;
import boxup.Error;
import boxup.Source;
import boxup.Parser;
import boxup.Node;

class DocumentProvider {
  // final previews:PreviewProvider;
  final definitions:DefinitionProvider;
  final reporter:Reporter;
  final parsedDocuments:Map<String, Array<Node>> = [];

  public function new(/*previews,*/ reporter, definitions) {
    // this.previews = previews;
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
    var source:Source = {
      filename: document.uri.toString(),
      content: document.getText()
    };
    try {
      var parser = new Parser(source);
      var nodes = parser.parse();
      switch definitions.getDefinitionFromNodes(nodes) {
        case None:
        case Some(definition): switch definition.validate(nodes) {
          case Passed:
          case Failed(errors): 
            reporter.report(errors, source);
        }
      }
      parsedDocuments.set(document.uri.toString(), nodes);
    } catch (e:Error) {
      reporter.report([ e ], source);
    }
    // previews.updatePreview(document.uri);
  }
}
