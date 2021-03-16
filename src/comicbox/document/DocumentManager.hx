package comicbox.document;

import boxup.Error;
import vscode.ExtensionContext;
import vscode.EventEmitter;
import vscode.TextDocument;
import boxup.Reporter;
import boxup.Source;
import boxup.Parser;
import boxup.Node;
import boxup.cli.DefinitionManager;
import comicbox.core.Plugin;

using comicbox.Util;

class DocumentManager implements Plugin {
  final manager:DefinitionManager;
  final reporter:Reporter;
  final parsedDocuments:Map<String, ComicboxDocument> = [];
  public final events:EventEmitter<{ doc:TextDocument, nodes:Array<Node>, source:Source }> = new EventEmitter();
  
  public function new(reporter, manager) {
    this.reporter = reporter;
    this.manager = manager;
  }

  public function register(context:ExtensionContext) {
    Vscode.workspace.onDidChangeTextDocument(change -> {
      if (change.document.isBoxupDocument()) {
        parseDocument(change.document);
      }
    });
    Vscode.workspace.onDidCloseTextDocument(document -> {
      if (document.isBoxupDocument()) {
        removeDocument(document.uri.toString());
      }
    });
    Vscode.window.onDidChangeActiveTextEditor(change -> {
      if (change.document.isBoxupDocument()) {
        parseDocument(change.document);
      }
    });
  }

  public function getDocument(uri:String):ComicboxDocument {
    return parsedDocuments.get(uri);
  }

  public function setDocument(uri:String, doc:ComicboxDocument) {
    parsedDocuments.set(uri, doc);
  }

  public function removeDocument(uri:String) {
    parsedDocuments.remove(uri);
  }

  public function parseDocument(document:TextDocument) {
    var source = new Source(document.uri.toString(), document.getText());
    var result = source.tokens
      .map(tokens -> new Parser(tokens).parse())
      .map(nodes -> switch manager.findDefinition(nodes, source) {
        case None: 
          Ok(nodes);
        case Some(def):
          def.validate(nodes, source);
      })
      .map(nodes -> {
        parsedDocuments.set(document.uri.toString(), {
          nodes: nodes,
          source: source
        });
        Ok(nodes);
      });
    switch result {
      case Ok(nodes):
        events.fire({
          doc: document,
          nodes: nodes,
          source: source
        });
      case Fail(error):
        reporter.report(error, source);
    }
  }
}