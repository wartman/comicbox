package comicbox.preview;

import boxup.Source;
import vscode.ExtensionContext;
import vscode.ViewColumn;
import vscode.TextDocument;
import vscode.Uri;
import vscode.Disposable;
import boxup.Node;
import comicbox.core.Plugin;
import comicbox.generator.HtmlGenerator;
import comicbox.document.DocumentManager;

using Lambda;
using comicbox.Util;

@:allow(comicbox.preview.PreviewPanel)
class PreviewManager implements Plugin {
  final previews:Array<PreviewPanel> = [];
  final disposables:Array<Disposable> = [];
  final generator:HtmlGenerator;
  final documents:DocumentManager;
  public final extensionUri:Uri;

  public function new(@:inject.tag('comicbox.uri') extensionUri, generator, documents) {
    this.extensionUri = extensionUri;
    this.generator = generator;
    this.documents = documents;
    this.documents.events.event((data) -> updatePreviewForDocument(data.doc, data.nodes, data.source));
  }

  public function register(context:ExtensionContext) {
    context.subscriptions.push(
      Vscode.commands.registerCommand('comicbox.showPreview', () -> {
        createPreview(Vscode.window.activeTextEditor.document);
      })
    );
    Vscode.window.registerWebviewPanelSerializer(
      PreviewPanel.viewType,
      new PreviewSerializer(this)
    );
  }

  public function addPreview(preview:PreviewPanel) {
    previews.push(preview);
  }

  public function updatePreviewForDocument(document:TextDocument, nodes:Array<Node>, source:Source) {
    var preview = getPreviewForDocument(document);
    if (preview == null) return;
    updatePreview(preview, nodes, source);
  }

  function updatePreview(preview:PreviewPanel, nodes:Array<Node>, source:Source) {
    switch generator.generate(nodes, source) {
      case Ok(html): 
        preview.updateHtml(html);
      case Fail(error): 
        Vscode.window.showErrorMessage(
          'Could not generate a preview: ' +
          [ for (e in error) e.message ].join('\n') 
        );
    }
  }
  
  public function getPreviewForDocument(document:TextDocument) {
    var path = document.uri.toString();
    return previews.find(p -> p.documentUri.toString() == path);
  }

  public function removePreviewForEditor(document:TextDocument) {
    var preview = getPreviewForDocument(document);
    if (preview != null) {
      previews.remove(preview);
      preview.dispose();
    }
  }

  public function createPreview(document:TextDocument) {
    if (!document.isBoxupDocument()) {
      Vscode.window.showErrorMessage('Only boxup documents can use the preview');
      return;
    }

    var preview = getPreviewForDocument(document);

    if (preview == null) {
      var panel = Vscode.window.createWebviewPanel(
        PreviewPanel.viewType,
        'Comicbox Preview',
        ViewColumn.Three,
        { enableScripts: true, retainContextWhenHidden: false }
      );
      preview = new PreviewPanel(
        document.uri,
        this,
        panel
      );
      addPreview(preview);
    }

    var doc = documents.getDocument(document.uri.toString());
    if (doc != null) updatePreview(preview, doc.nodes, doc.source);
  }

  public function dispose() {
    while (previews.length > 0) {
      var preview = previews.pop();
      preview.dispose();
    }
    while (disposables.length > 0) {
      var disposable = disposables.pop();
      disposable.dispose();
    }
  }
}