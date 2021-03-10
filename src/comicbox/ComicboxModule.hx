package comicbox;

import vscode.Uri;
import capsule.Container;
import capsule.ServiceProvider;
import boxup.Reporter;
import comicbox.boxup.VscodeReporter;
import comicbox.generator.HtmlGenerator;

class ComicboxModule implements ServiceProvider {
  final config:ComicboxConfig;
  
  public function new(config) {
    this.config = config;
  }

  public function register(container:Container) {
    container.map(ComicboxConfig).to(config);
    container.map(Uri, 'comicbox.uri').toShared(function (config:ComicboxConfig) {
      return config.extensionUri;
    });
    container.map(Reporter).toShared(VscodeReporter);
    container.map(HtmlGenerator).toShared(HtmlGenerator);
  }
}
