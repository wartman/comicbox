package comicbox;

import vscode.Uri;
import capsule.Container;
import capsule.ServiceProvider;
import boxup.Reporter;
import comicbox.boxup.VscodeReporter;
import comicbox.provider.DiagnosticsProvider;
import comicbox.provider.DefinitionProvider;
import comicbox.provider.DocumentProvider;
import comicbox.generator.HtmlGenerator;
import comicbox.preview.PreviewManager;
// import comicbox.provider.CompletionProvider;

class ComicboxModule implements ServiceProvider {
  final extensionUri:Uri;
  
  public function new(extensionUri) {
    this.extensionUri = extensionUri;
  }

  public function register(container:Container) {
    container.map(Uri, 'comicbox.uri').toShared(extensionUri);
    container.map(Reporter).toShared(VscodeReporter);
    container.map(HtmlGenerator).toShared(HtmlGenerator);
    // container.map(CompletionProvider).toShared(CompletionProvider);
    container.map(DiagnosticsProvider).toShared(DiagnosticsProvider);
    container.map(DefinitionProvider).toShared(DefinitionProvider);
    container.map(DocumentProvider).toShared(DocumentProvider);
    container.map(PreviewManager).toShared(PreviewManager);
  }
}
