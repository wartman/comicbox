import comicbox.provider.DiagnosticsProvider;
import comicbox.provider.DocumentProvider;
import comicbox.ComicboxModule;
import capsule.Container;
import vscode.ExtensionContext;

using comicbox.Util;

@:expose('activate')
function activate(context:ExtensionContext) {
  var container = new Container();
  
  container.use(ComicboxModule);
  
  var docs = container.get(DocumentProvider);
  var diag = container.get(DiagnosticsProvider);

  diag.register(context);

  Vscode.workspace.onDidChangeTextDocument(change -> {
    if (change.document.isBoxupDocument()) {
      diag.clear(change.document.uri);
      docs.parseDocument(change.document);
    }
  });

  Vscode.workspace.onDidCloseTextDocument(document -> {
    if (document.isBoxupDocument()) {
      docs.removeDocument(document.uri.toString());
      diag.remove(document.uri);
    }
  });

  Vscode.window.onDidChangeActiveTextEditor(change -> {
    if (change.document.isBoxupDocument()) {
      diag.clear(change.document.uri);
      docs.parseDocument(change.document);
    }
  });

  context.subscriptions.push(
    Vscode.commands.registerCommand('comicbox.compile', function () {
      Vscode.window.showInformationMessage('Not ready yet');
    })
  );

  // // context.subscriptions.push(Vscode.commands.registerCommand('comicbox.test', function () {
  // //   Vscode.window.showInformationMessage('Testing Comicbox');
  // // }));
}
