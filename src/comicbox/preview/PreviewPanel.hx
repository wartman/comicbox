package comicbox.preview;

import vscode.Disposable;
import vscode.Uri;
import vscode.WebviewPanel;

class PreviewPanel {
  public static inline final viewType = 'comicbox-preview';
  static var uid:Int = 0;

  public final id = uid++;
  public final documentUri:Uri;
  public final manager:PreviewManager;
  public final panel:WebviewPanel;
  final disposables:Array<Disposable> = []; // unneded??

  public function new(docuemntUri, manager, panel) {
    this.documentUri = docuemntUri;
    this.manager = manager;
    this.panel = panel;
    
    init();

    panel.onDidDispose(_ -> dispose(), null, disposables);
    panel.webview.onDidReceiveMessage(message -> {
      handleMessages(message);
    }, null, disposables);
  }

  public function updateHtml(content:String) {
    panel.webview.postMessage({ command: 'updateHtml', content: content });
  }

  public function updateState(state:PreviewState) {
    panel.webview.postMessage({ command: 'upsateState', state: state });
  }

  function init() {
    panel.title = 'Comicbox Preview';
    panel.webview.html = render();
    updateState({ 
      uri: documentUri.toString() 
    });
  }

  public function dispose() {
    manager.previews.remove(this);
    panel.dispose();
    while (disposables.length > 0) {
      var disposable = disposables.pop();
      disposable.dispose();
    }
  }

  function render() {
    var scriptSrc = Uri.joinPath(manager.extensionUri, 'dist', 'assets', 'preview.js');
    var scriptPath = panel.webview.asWebviewUri(scriptSrc);
    return '
      <!doctype html>
			<html lang="en">
        <head>
          <meta charset="UTF-8">
          <title>Comicbox Preview</title>
          <style>
            a {
              color: inherit;
            }
            a:hover {
              color: inherit;
            }
            h1, h2, h3, h4 {
              font-weight: normal;
              margin: 10px 0;
              text-transform: uppercase;
            }
            h2, h3, h4 {
              font-size: inherit;
            }
            .comic {
              margin-bottom: 20px;
            }
            .notes {
              font-style: italic;
              padding: 5px 20px;
              background: #f7f7f7;
              color: #8a8a8a;
              margin-bottom: 40px;
            }
            .page {
              padding-left: 10px;
              padding-top: 10px;
              border-top: 1px solid;
              margin-bottom: 40px;
            }
            .page h2 {
              color: #cccccc;
            }
            .panel {
              margin-bottom: 40px;
            }
            .panel .attached:before {
              content: "(attached)";
              color: #8a8a8a;
            }
            .panel .mood {
              color: #8a8a8a;
            }
            .dialog {
              text-align: center;
              margin-bottom: 20px;
            }
          </style>
        </head>
        <body>
          <div id="target"></div>
          <script src="${scriptPath}"></script>
        </body>
      </html>
    ';
  }

  function handleMessages(message:String) {
    
  }
}
