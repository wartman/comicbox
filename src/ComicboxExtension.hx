import vscode.Uri;
import vscode.ExtensionContext;
import capsule.Container;
import comicbox.document.DocumentModule;
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

  var manager = container.get(PluginManager);
  manager.register(context);
}
