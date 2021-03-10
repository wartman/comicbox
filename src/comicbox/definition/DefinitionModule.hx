package comicbox.definition;

import capsule.Container;
import capsule.ServiceProvider;

class DefinitionModule implements ServiceProvider {
  public function new() {}

  public function register(container:Container) {
    container.map(DefintionManager).toShared(DefintionManager);
    container.map(ComicboxValidator).toShared(ComicboxValidator);
  }
}
