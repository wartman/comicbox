import vscode.Uri;
import vscode.ExtensionContext;
import capsule.Container;
import comicbox.document.DocumentManager;
import comicbox.document.DocumentModule;
import comicbox.diagnostic.DiagnosticManager;
import comicbox.diagnostic.DiagnosticModule;
import comicbox.core.PluginManager;
import comicbox.ComicboxModule;
import comicbox.core.PluginModule;
import comicbox.preview.PreviewModule;
import comicbox.definition.DefinitionModule;
import comicbox.render.RenderModule;

using comicbox.Util;

@:expose('activate')
function activate(context:ExtensionContext) {
  var container = new Container();
  
  container.use(PluginModule);
  container.use(new ComicboxModule({
    extensionUri: Uri.parse(context.extensionUri)
  }));
  container.use(DiagnosticModule);
  container.use(DefinitionModule);
  container.use(DocumentModule);
  container.use(PreviewModule);
  container.use(RenderModule);
  
  var docs = container.get(DocumentManager);
  var diag = container.get(DiagnosticManager);

  container.get(PluginManager).register(context);

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
      docs.parseDocument(change.document);
    }
  });
}
