package comicbox.definition;

import boxup.Validator;
import capsule.Container;
import capsule.ServiceProvider;
import boxup.Reporter;
import boxup.cli.AutoValidator;
import boxup.cli.DefinitionManager;
import boxup.cli.loader.ResourceLoader;
import comicbox.boxup.NodeResolver;

class DefinitionModule implements ServiceProvider {
  public function new() {}

  public function register(container:Container) {
    container.map(DefinitionManager).toShared(function (reporter:Reporter) {
      return new DefinitionManager(
        [ new NodeResolver() ],
        [ new ResourceLoader() ],
        reporter
      );
    });
    container.map(Validator).toShared(AutoValidator);
  }
}
