package comicbox.document;

import capsule.Container;
import capsule.ServiceProvider;

class DocumentModule implements ServiceProvider {
  public function new() {}

  public function register(container:Container) {
    container.map(DocumentManager).toShared(DocumentManager);
  }
}
