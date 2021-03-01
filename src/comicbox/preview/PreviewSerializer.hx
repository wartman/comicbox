package comicbox.preview;

import vscode.Uri;
import js.lib.Promise;
import vscode.WebviewPanel;
// import vscode.WebviewPanelSerializer;

class PreviewSerializer {
  public final manager:PreviewManager;

  public function new(manager) {
    this.manager = manager;
  }
  
  public function deserializeWebviewPanel(webviewPanel:WebviewPanel, state:{ id:String }):Thenable<Void> {
    var preview = new PreviewPanel(
      Uri.parse(state.id),
      manager,
      webviewPanel
    );
    manager.addPreview(preview);
    return Promise.resolve();
  }
}
