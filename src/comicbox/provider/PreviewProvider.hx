package comicbox.provider;

import vscode.ViewColumn;
import vscode.Uri;
import vscode.TextEditor;
import vscode.WebviewPanel;
import comicbox.generator.HtmlGenerator;

using Lambda;
using haxe.io.Path;
using comicbox.Util;

typedef Preview = {
  id:Int,
  uri:String,
  panel:WebviewPanel,
  isDynamic:Bool
};

class PreviewProvider {
  final generator:HtmlGenerator;
  final documents:DocumentProvider;
  final previews:Array<Preview> = [];

  public function new(generator, documents) {
    this.generator = generator;
    this.documents = documents;
  }

  public function createPreviewPanel(editor:TextEditor, isDynamic:Bool):WebviewPanel {
    if (!editor.document.isBoxupDocument()) {
      Vscode.window.showErrorMessage('Only boxup documents can use the preview');
      return null;
    }

    var preview:WebviewPanel = null;
    // var existingPreviews = 

    // todo: find if a preview already exists

    if (preview == null) {
      var name = isDynamic 
        ? 'Comicbox Preview'
        : editor.document.fileName.withoutDirectory().withoutExtension();
      preview = Vscode.window.createWebviewPanel(
        'boxup-preview',
        name,
        ViewColumn.Three,
        { enableScripts: true, retainContextWhenHidden: false }
      );
    }

    // setupWebView()

    return preview;
  }

  function removePreview(id:Int) {
    previews.remove(previews.find(p -> p.id == id));
  }

  function setupPreview(uri:Uri, preview:WebviewPanel, isDynamic:Bool) {
    var id:Int = Math.floor(Date.now().getTime() + Math.floor(Math.random() * 1000));
    previews.push({
      id: id,
      uri: uri.toString(),
      panel: preview,
      isDynamic: isDynamic
    });
    preview.onDidDispose(_ -> removePreview(id));
  }
}
