package comicbox;

import boxup.Reporter;
import capsule.Container;
import capsule.ServiceProvider;
import comicbox.boxup.VscodeReporter;
// import comicbox.generator.HtmlGenerator;
// import comicbox.provider.PreviewProvider;
import comicbox.provider.DiagnosticsProvider;
import comicbox.provider.DefinitionProvider;
import comicbox.provider.DocumentProvider;
// import comicbox.provider.CompletionProvider;

class ComicboxModule implements ServiceProvider {
  public function new() {
    // todo
  }

  public function register(container:Container) {
    container.map(Reporter).toShared(VscodeReporter);
    // container.map(CompletionProvider).toShared(CompletionProvider);
    container.map(DiagnosticsProvider).toShared(DiagnosticsProvider);
    container.map(DefinitionProvider).toShared(DefinitionProvider);
    container.map(DocumentProvider).toShared(DocumentProvider);
    // container.map(HtmlGenerator).toShared(HtmlGenerator);
    // container.map(PreviewProvider).toShared(PreviewProvider);
  }
}
